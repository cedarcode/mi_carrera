module YmlLoader
  extend self

  def load
    load_subject_groups
    load_subjects
    load_prerequisites
  end

  private

  def load_subject_groups
    subject_groups = YAML.load_file(Rails.root.join("db/data/scraped_subject_groups.yml"))
    subject_groups.each do |code, yml_group|
      subject_group = SubjectGroup.find_or_initialize_by(code:)
      subject_group.name = format_name(yml_group["name"])
      subject_group.save!
    end
  end

  def load_subjects
    subjects = YAML.load_file(Rails.root.join("db/data/scraped_subjects.yml"))
    subjects_overrides = YAML.load_file(Rails.root.join("db/data/subject_overrides.yml"))

    subjects.each do |code, subject|
      new_subject = Subject.find_or_initialize_by(code:)

      new_subject.name = format_name(subject["name"])
      new_subject.credits = subject["credits"]
      new_subject.group = SubjectGroup.find_by(code: subject["subject_group"])

      subject_overrides = subjects_overrides[code] || {}
      new_subject.eva_id = subject_overrides['eva_id']
      new_subject.openfing_id = subject_overrides['openfing_id']
      new_subject.short_name = subject_overrides['short_name']
      new_subject.category = subject_overrides['category'] || 'optional'

      new_subject.save!

      new_subject.create_course! unless new_subject.course
      new_subject.create_exam! if subject["has_exam"] && !new_subject.exam
    end
  end

  def load_prerequisites
    prerequisites = YAML.load_file(Rails.root.join("db/data/scraped_prerequisites.yml"))

    Prerequisite.destroy_all

    prerequisites.each do |prerequisite|
      subject = Subject.find_by(code: prerequisite["subject_code"])
      approvable = prerequisite["is_exam"] ? subject.exam : subject.course
      approvable.prerequisite_tree = prerequisite_tree(prerequisite)
      approvable.save!
    end
  end

  def format_name(name)
    name.split.map do |word|
      if ['I', 'II', 'III', 'IV', 'V'].include?(word)
        word
      else
        (typos_list[word.downcase] || word).capitalize
      end
    end.join(' ')
  end

  def typos_list
    @typos_list ||= YAML.load_file(Rails.root.join("lib/typos_list.yml"))
  end

  def prerequisite_tree(prerequisite)
    case prerequisite["type"]
    when 'logical'
      operands_prerequisites = prerequisite["operands"].filter_map { |operand| prerequisite_tree(operand) }

      LogicalPrerequisite.new(
        logical_operator: prerequisite["logical_operator"],
        amount_of_subjects_needed: prerequisite["amount_of_subjects_needed"],
        operands_prerequisites:
      ) if operands_prerequisites.present?
    when 'subject'
      subject = Subject.find_by!(code: prerequisite["subject_needed_code"])

      approvable_needed = 
        case prerequisite["needs"]
        when 'exam'
          subject.exam
        when 'course'
          subject.course
        when 'enrollment'
          subject.course
        when 'all'
          subject.exam || subject.course
        else
          raise "Unknown approvable needed: #{prerequisite["needs"]}"
        end
      
      if prerequisite["needs"] == 'enrollment'
        EnrollmentPrerequisite.new(approvable_needed:)
      else
        SubjectPrerequisite.new(approvable_needed:)
      end
    when 'credits'
      subject_group = prerequisite["group"] ? SubjectGroup.find_by(code: prerequisite["group"]) : nil
      CreditsPrerequisite.new(credits_needed: prerequisite["credits"], subject_group:)
    else
      raise "Unknown prerequisite type: #{prerequisite["type"]}"
    end
  end
end
