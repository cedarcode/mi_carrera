require "rails_helper"

RSpec.describe SubjectGraphComponent, type: :component do
  let(:user) { build_stubbed(:user) }
  let(:student) { UserStudent.new(user) }

  context "with subjects" do
    it "renders the graph container with data attributes" do
      subject1 = create(:subject, name: "Subject 1", code: "S1")

      render_inline(described_class.new(subjects: [subject1], current_student: student))

      expect(page).to have_css "[data-controller='subject-graph']"
      expect(page).to have_css "[data-subject-graph-nodes-value]"
      expect(page).to have_css "[data-subject-graph-edges-value]"
    end

    it "includes subject data in nodes" do
      subject1 = create(:subject, name: "Test Subject", short_name: "TS", code: "TS1")

      render_inline(described_class.new(subjects: [subject1], current_student: student))

      node_data = page.find("[data-subject-graph-nodes-value]")["data-subject-graph-nodes-value"]
      nodes = JSON.parse(node_data)

      expect(nodes.length).to eq(1)
      expect(nodes.first["id"]).to eq(subject1.id)
      expect(nodes.first["code"]).to eq("TS1")
      expect(nodes.first["name"]).to eq("TS")
      expect(nodes.first["url"]).to eq("/materias/#{subject1.id}")
    end

    it "uses full name when short_name is not present" do
      subject1 = create(:subject, name: "Full Name Subject", short_name: nil, code: "FN1")

      render_inline(described_class.new(subjects: [subject1], current_student: student))

      node_data = page.find("[data-subject-graph-nodes-value]")["data-subject-graph-nodes-value"]
      nodes = JSON.parse(node_data)

      expect(nodes.first["name"]).to eq("Full Name Subject")
    end

    it "marks available subjects as available" do
      subject1 = create(:subject, name: "Available Subject", code: "AV1")

      render_inline(described_class.new(subjects: [subject1], current_student: student))

      node_data = page.find("[data-subject-graph-nodes-value]")["data-subject-graph-nodes-value"]
      nodes = JSON.parse(node_data)

      expect(nodes.first["available"]).to be true
    end
  end

  context "with prerequisites" do
    it "creates edges for subject prerequisites within the subject set" do
      subject1 = create(:subject, name: "Prereq", code: "PR1")
      subject2 = create(:subject, name: "Dependent", code: "DE1")

      create(:subject_prerequisite, approvable: subject2.course, approvable_needed: subject1.course)

      render_inline(described_class.new(subjects: [subject1, subject2], current_student: student))

      edge_data = page.find("[data-subject-graph-edges-value]")["data-subject-graph-edges-value"]
      edges = JSON.parse(edge_data)

      expect(edges.length).to eq(1)
      expect(edges.first["source"]).to eq(subject1.id)
      expect(edges.first["target"]).to eq(subject2.id)
    end

    it "does not create edges for prerequisites outside the subject set" do
      subject1 = create(:subject, name: "Outside", code: "OU1")
      subject2 = create(:subject, name: "Inside", code: "IN1")

      create(:subject_prerequisite, approvable: subject2.course, approvable_needed: subject1.course)

      # Only include subject2, not subject1
      render_inline(described_class.new(subjects: [subject2], current_student: student))

      edge_data = page.find("[data-subject-graph-edges-value]")["data-subject-graph-edges-value"]
      edges = JSON.parse(edge_data)

      expect(edges).to be_empty
    end

    it "handles logical prerequisites with multiple operands" do
      subject1 = create(:subject, name: "Prereq 1", code: "PR1")
      subject2 = create(:subject, name: "Prereq 2", code: "PR2")
      subject3 = create(:subject, name: "Dependent", code: "DE1")

      create(:and_prerequisite, approvable: subject3.course, operands_prerequisites: [
        create(:subject_prerequisite, approvable_needed: subject1.course),
        create(:subject_prerequisite, approvable_needed: subject2.course),
      ])

      render_inline(described_class.new(subjects: [subject1, subject2, subject3], current_student: student))

      edge_data = page.find("[data-subject-graph-edges-value]")["data-subject-graph-edges-value"]
      edges = JSON.parse(edge_data)

      expect(edges.length).to eq(2)
      sources = edges.map { |e| e["source"] }
      expect(sources).to contain_exactly(subject1.id, subject2.id)
      expect(edges.all? { |e| e["target"] == subject3.id }).to be true
    end
  end

  context "without subjects" do
    it "renders empty arrays for nodes and edges" do
      render_inline(described_class.new(subjects: [], current_student: student))

      node_data = page.find("[data-subject-graph-nodes-value]")["data-subject-graph-nodes-value"]
      edge_data = page.find("[data-subject-graph-edges-value]")["data-subject-graph-edges-value"]

      expect(JSON.parse(node_data)).to be_empty
      expect(JSON.parse(edge_data)).to be_empty
    end
  end
end
