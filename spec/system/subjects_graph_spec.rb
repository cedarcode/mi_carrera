require 'rails_helper'

RSpec.describe "Subjects Graph", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "displays graph filtered by single category" do
    create(:subject, name: "First Sem Subject", code: "FS1", category: "first_semester")
    create(:subject, name: "Second Sem Subject", code: "SS1", category: "second_semester")

    visit subjects_graph_path(categories: ["first_semester"])

    expect(page).to have_css "[data-controller='subject-graph']"

    node_data = find("[data-subject-graph-nodes-value]")["data-subject-graph-nodes-value"]
    nodes = JSON.parse(node_data)

    expect(nodes.length).to eq(1)
    expect(nodes.first["code"]).to eq("FS1")
  end

  it "displays graph filtered by multiple categories" do
    create(:subject, name: "First Sem Subject", code: "FS1", category: "first_semester")
    create(:subject, name: "Second Sem Subject", code: "SS1", category: "second_semester")
    create(:subject, name: "Third Sem Subject", code: "TS1", category: "third_semester")

    visit subjects_graph_path(categories: ["first_semester", "second_semester"])

    node_data = find("[data-subject-graph-nodes-value]")["data-subject-graph-nodes-value"]
    nodes = JSON.parse(node_data)

    expect(nodes.length).to eq(2)
    expect(nodes.map { |n| n["code"] }).to contain_exactly("FS1", "SS1")
  end

  it "shows edges for prerequisites within filtered subjects" do
    subject1 = create(:subject, name: "Intro", code: "IN1", category: "first_semester")
    subject2 = create(:subject, name: "Advanced", code: "AD1", category: "first_semester")

    create(:subject_prerequisite, approvable: subject2.course, approvable_needed: subject1.course)

    visit subjects_graph_path(categories: ["first_semester"])

    edge_data = find("[data-subject-graph-edges-value]")["data-subject-graph-edges-value"]
    edges = JSON.parse(edge_data)

    expect(edges.length).to eq(1)
    expect(edges.first["source"]).to eq(subject1.id)
    expect(edges.first["target"]).to eq(subject2.id)
  end

  it "shows empty state when no categories provided" do
    create(:subject, name: "Some Subject", code: "SS1", category: "first_semester")

    visit subjects_graph_path

    expect(page).to have_text "No hay materias para mostrar"
  end

  it "marks available subjects based on user approvals" do
    prereq_subject = create(:subject, name: "Prerequisite", code: "PR1", category: "first_semester")
    dependent_subject = create(:subject, name: "Dependent", code: "DE1", category: "first_semester")

    create(:subject_prerequisite, approvable: dependent_subject.course, approvable_needed: prereq_subject.course)

    # Approve the prerequisite
    user.approvals << prereq_subject.course.id
    user.save!

    visit subjects_graph_path(categories: ["first_semester"])

    node_data = find("[data-subject-graph-nodes-value]")["data-subject-graph-nodes-value"]
    nodes = JSON.parse(node_data)

    prereq_node = nodes.find { |n| n["code"] == "PR1" }
    dependent_node = nodes.find { |n| n["code"] == "DE1" }

    # Prereq has no prereqs, so it's available
    expect(prereq_node["available"]).to be true
    # Dependent should now be available since prereq is approved
    expect(dependent_node["available"]).to be true
  end
end
