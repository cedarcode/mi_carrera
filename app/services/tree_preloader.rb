class TreePreloader
  def initialize(subjects = nil)
    @subjects = subjects || Subject.all
  end

  def preload
    # rubocop:disable Rails/FindEach
    subjects
      .ordered_by_category_and_name
      .includes(
        course: :prerequisite_tree,
        exam: :prerequisite_tree
      ).each do |subject|
      preload_prerequisite(subject.course.prerequisite_tree) if subject.course&.prerequisite_tree
      preload_prerequisite(subject.exam.prerequisite_tree) if subject.exam&.prerequisite_tree
    end
    # rubocop:enable Rails/FindEach
  end

  private

  attr_reader :subjects

  def preload_prerequisite(prereq)
    case prereq
    when LogicalPrerequisite
      prereq.association(:operands_prerequisites).target = prerequisites_by_parent_prerequisite_id[prereq.id] || []
      prereq.operands_prerequisites.each { |p| preload_prerequisite(p) }
    when CreditsPrerequisite
      prereq.association(:subject_group).target = subject_groups_by_id[prereq.subject_group_id]
    when SubjectPrerequisite
      prereq.association(:approvable_needed).target = approvable_by_id[prereq.approvable_needed_id]
    when EnrollmentPrerequisite
      prereq.association(:approvable_needed).target = approvable_by_id[prereq.approvable_needed_id]
    else
      raise "Unknown prerequisite type: #{prereq.class}"
    end
  end

  def prerequisites_by_parent_prerequisite_id
    @prerequisites_by_parent_prerequisite_id ||= Prerequisite.all.group_by(&:parent_prerequisite_id)
  end

  def subject_groups_by_id
    @subject_groups_by_id ||= SubjectGroup.all.index_by(&:id)
  end

  def approvable_by_id
    @approvable_by_id ||= Approvable.all.index_by(&:id)
  end
end
