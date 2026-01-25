require 'rails_helper'

RSpec.describe "Planner Graph", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "displays graph with planned subjects" do
    subject1 = create(:subject, name: "Calculo 1", code: "C1")
    subject2 = create(:subject, name: "Calculo 2", code: "C2")

    create(:subject_prerequisite, approvable: subject2.course, approvable_needed: subject1.course)

    create(:subject_plan, user: user, subject: subject1, semester: 1)
    create(:subject_plan, user: user, subject: subject2, semester: 2)

    visit planner_graph_path

    expect(page).to have_css "[data-controller='subject-graph']"
    expect(page).to have_css "[data-subject-graph-nodes-value]"
    expect(page).to have_css "[data-subject-graph-edges-value]"

    node_data = find("[data-subject-graph-nodes-value]")["data-subject-graph-nodes-value"]
    nodes = JSON.parse(node_data)

    expect(nodes.length).to eq(2)
    expect(nodes.map { |n| n["code"] }).to contain_exactly("C1", "C2")
  end

  it "shows empty state when no planned subjects" do
    visit planner_graph_path

    expect(page).to have_text "No tienes materias planificadas"
    expect(page).to have_link "Agregar materias"
  end

  it "includes edges for prerequisites within planned subjects" do
    subject1 = create(:subject, name: "Base", code: "B1")
    subject2 = create(:subject, name: "Advanced", code: "A1")

    create(:subject_prerequisite, approvable: subject2.course, approvable_needed: subject1.course)

    create(:subject_plan, user: user, subject: subject1, semester: 1)
    create(:subject_plan, user: user, subject: subject2, semester: 2)

    visit planner_graph_path

    edge_data = find("[data-subject-graph-edges-value]")["data-subject-graph-edges-value"]
    edges = JSON.parse(edge_data)

    expect(edges.length).to eq(1)
    expect(edges.first["source"]).to eq(subject1.id)
    expect(edges.first["target"]).to eq(subject2.id)
  end

  it "marks available subjects in the graph data" do
    subject1 = create(:subject, name: "Available", code: "AV")
    create(:subject_plan, user: user, subject: subject1, semester: 1)

    visit planner_graph_path

    node_data = find("[data-subject-graph-nodes-value]")["data-subject-graph-nodes-value"]
    nodes = JSON.parse(node_data)

    available_node = nodes.find { |n| n["code"] == "AV" }
    expect(available_node["available"]).to be true
  end
end
