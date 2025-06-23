class TreePreloader
  SUBJECTS_KEY = 'preloaded_subjects'.freeze
  TIME_TO_LIVE = 12.hours

  def initialize(subjects)
    @subjects = subjects
  end

  def preload
    subjects.to_a.each do |subject|
      preloaded_subject = preloaded_subjects[subject.id]
      subject.association(:course).target = preloaded_subject.course
      subject.association(:exam).target = preloaded_subject.exam
    end
  end

  def clear_cache
    Rails.cache.delete(SUBJECTS_KEY)
  end

  private

  attr_reader :subjects

  def preloaded_subjects
    @preloaded_subjects ||= Rails.cache.fetch(SUBJECTS_KEY, expires_in: TIME_TO_LIVE) do
      Subject
        .includes(course: :prerequisite_tree, exam: :prerequisite_tree)
        .to_a
        .each do |subject|
        course = subject.course
        exam = subject.exam
        preload_prerequisite(course.prerequisite_tree) if course&.prerequisite_tree
        preload_prerequisite(exam.prerequisite_tree) if exam&.prerequisite_tree
      end.index_by(&:id)
    end
  end

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
    when ActivityPrerequisite
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
