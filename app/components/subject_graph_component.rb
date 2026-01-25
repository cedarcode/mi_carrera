# frozen_string_literal: true

class SubjectGraphComponent < ViewComponent::Base
  def initialize(subjects:, current_student:)
    @subjects = subjects
    @current_student = current_student
  end

  def nodes
    @subjects.map do |subject|
      {
        id: subject.id,
        code: subject.code,
        name: subject.short_name || subject.name,
        url: helpers.subject_path(subject),
        available: @current_student.available?(subject),
        completed: @current_student.approved?(subject)
      }
    end
  end

  def edges
    subject_ids = Set.new(@subjects.map(&:id))
    edges = []

    @subjects.each do |subject|
      collect_prerequisite_edges(subject.course&.prerequisite_tree, subject.id, subject_ids, edges)
    end

    edges.uniq
  end

  private

  def collect_prerequisite_edges(prerequisite, target_subject_id, subject_ids, edges)
    return unless prerequisite

    case prerequisite
    when SubjectPrerequisite
      source_subject_id = prerequisite.approvable_needed.subject_id
      if subject_ids.include?(source_subject_id)
        edges << { source: source_subject_id, target: target_subject_id }
      end
    when LogicalPrerequisite
      # Skip "not" operators - they represent inverse relationships
      return if prerequisite.logical_operator == "not"

      prerequisite.operands_prerequisites.each do |child|
        collect_prerequisite_edges(child, target_subject_id, subject_ids, edges)
      end
    end
  end
end
