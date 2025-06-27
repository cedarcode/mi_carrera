class PreloadedApprovablesFetcher
  class << self
    def data
      @data ||= new.fetch
    end

    def reload!
      @data = new.fetch
    end
  end

  def fetch
    approvable_by_id.each_value do |approvable|
      next if approvable.prerequisite_tree.blank?

      preload_prerequisite(approvable.prerequisite_tree)
    end
    .values
    .group_by(&:subject_id)
    .to_h do |subject_id, approvables|
      exam = approvables.find(&:is_exam?)
      course = approvables.find { |a| !a.is_exam? }

      [
        subject_id,
        {
          course:,
          exam:,
        }
      ]
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
    when SubjectPrerequisite, EnrollmentPrerequisite, ActivityPrerequisite
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
    @approvable_by_id ||= Approvable.includes(:prerequisite_tree).index_by(&:id)
  end
end
