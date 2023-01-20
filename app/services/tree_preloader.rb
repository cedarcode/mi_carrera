class TreePreloader
  def preload
    Subject
      .ordered_by_semester_and_name
      .includes(
        course: :prerequisite_tree,
        exam: :prerequisite_tree
      ).each do |subject|
      preload_prerequisite(subject.course.prerequisite_tree) if subject.course&.prerequisite_tree
      preload_prerequisite(subject.exam.prerequisite_tree) if subject.exam&.prerequisite_tree
    end
  end

  private

  def preload_prerequisite(prereq)
    case prereq
    when LogicalPrerequisite
      prereq.association(:operands_prerequisites).target = prerequisites_by_parent_prerequisite_id[prereq.id] || []
      prereq.operands_prerequisites.each { |p| preload_prerequisite(p) }
    when CreditsPrerequisite
      prereq.association(:subject_group).target = subject_groups_by_id[prereq.subject_group_id]
    when SubjectPrerequisite
      # rubocop:disable Lint/Debugger
      byebug if prereq.approvable_needed_id.nil? || approvable_by_id[prereq.approvable_needed_id].nil?
      # rubocop:enable Lint/Debugger
      prereq.association(:approvable_needed).target = approvable_by_id[prereq.approvable_needed_id]
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
