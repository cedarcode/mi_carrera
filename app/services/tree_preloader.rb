class TreePreloader
  class << self
    def break_cache!
      @prerequisites_by_parent_prerequisite_id = nil
      @subject_groups_by_id = nil
      @approvable_by_id = nil
      @preloaded_approvables_by_subject_id = nil
    end

    def preload(subjects)
      subjects.to_a.each do |subject|
        approvables = preloaded_approvables_by_subject_id[subject.id]
        next if approvables.blank?

        subject.association(:course).target = approvables.find(&:is_course?)
        subject.association(:exam).target = approvables.find(&:is_exam?)
      end
    end

    private

    def preloaded_approvables_by_subject_id
      @preloaded_approvables_by_subject_id ||=
        approvable_by_id.each_value do |approvable|
          next if approvable.prerequisite_tree.blank?

          preload_prerequisite(approvable.prerequisite_tree)
        end
        .values
        .group_by(&:subject_id)
    end

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
end
