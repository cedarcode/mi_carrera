module YmlLoader
  extend self

  def load
    subject_groups = YAML.load_file(Rails.root.join("db/data/scraped_subject_groups.yml"))
    subjects = YAML.load_file(Rails.root.join("db/data/scraped_subjects.yml"))
    subject_overrides = YAML.load_file(Rails.root.join("db/data/subject_overrides.yml"))
    prerequisites = YAML.load_file(Rails.root.join("db/data/scraped_prerequisites.yml"))

    # first create/update all subject groups
    subject_groups.each do |_code, group|
      puts "Updating group #{group["code"]}"
      subject_group = SubjectGroup.find_or_initialize_by(code: group["code"])
      subject_group.name = format_name(group["name"])
      subject_group.save!
    end

    # then create/update all subjects
    subjects.each do |code, subject|
      puts "Updating subject #{code}"
      new_subject = Subject.find_or_initialize_by(code:)

      # capitalize only the first letter of words
      new_subject.name = format_name(subject["name"])
      new_subject.credits = subject["credits"]
      new_subject.group = SubjectGroup.find_by(code: subject["subject_group"])

      new_subject.eva_id = subject_overrides.dig(code, 'eva_id')
      new_subject.openfing_id = subject_overrides.dig(code, 'openfing_id')
      new_subject.short_name = subject_overrides.dig(code, 'short_name')
      new_subject.category = subject_overrides.dig(code, 'category') || 'optional'

      new_subject.save!

      # create the approvables
      new_subject.create_course! unless new_subject.course
      new_subject.create_exam! if subject["has_exam"] && !new_subject.exam
    end

    # destroy all prerequisites
    Prerequisite.destroy_all

    prerequisites.each do |prerequisite|
      puts "Updating prerequisite of subject #{prerequisite["subject_code"]}, is_exam: #{prerequisite["is_exam"]}"
      subject = Subject.find_by(code: prerequisite["subject_code"])
      approvable = prerequisite["is_exam"] ? subject.exam : subject.course
      approvable.prerequisite_tree = prerequisite_tree(prerequisite: prerequisite, approvable: approvable)
      approvable.save!
    end
  end

  private

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

  def prerequisite_tree(prerequisite:, approvable: nil, parent_prerequisite: nil)
    case prerequisite["type"]
    when 'logical'
      logical_prerequisite = LogicalPrerequisite.new(
        approvable: approvable,
        parent_prerequisite: parent_prerequisite,
        logical_operator: prerequisite["logical_operator"],
        amount_of_subjects_needed: prerequisite["amount_of_subjects_needed"],
      )

      prerequisite["operands"].each do |prerequisite_op|
        operand = prerequisite_tree(prerequisite: prerequisite_op, parent_prerequisite: logical_prerequisite)
        if operand
          logical_prerequisite.operands_prerequisites << operand
        end
      end

      # if all operands are nil don't add this prerequisite
      return nil if logical_prerequisite.operands_prerequisites.empty?

      logical_prerequisite.save!
      logical_prerequisite
    when 'subject'
      subject_prerequisite = SubjectPrerequisite.new(
        approvable: approvable,
        parent_prerequisite: parent_prerequisite
      )

      subject = Subject.find_by(code: prerequisite["subject_needed_code"])
      # if a subject which isn't in the system is required me don't add that prerequisite
      return nil unless subject
      return nil if prerequisite["needs"] == 'exam' && subject.exam.nil?

      subject_prerequisite.approvable_needed =
        if prerequisite["needs"] == 'exam'
          subject.exam
        elsif prerequisite["needs"] == 'all'
          subject.exam || subject.course
        else
          subject.course
        end

      subject_prerequisite.save!
      subject_prerequisite
    when 'credits'
      credits_prerequisite = CreditsPrerequisite.new(
        approvable: approvable,
        parent_prerequisite: parent_prerequisite,
        credits_needed: prerequisite["credits"],
        subject_group: prerequisite["group"] ? SubjectGroup.find_by(code: prerequisite["group"]) : nil
      )

      credits_prerequisite.save!
      credits_prerequisite
    else
      raise "Unknown prerequisite type: #{prerequisite["type"]}"
    end
  end
end
