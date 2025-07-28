class YmlLoader
  BASE_DIR = Rails.root.join("db/data")

  def self.load
    degrees = Rails.configuration.degrees
    degrees.each do |degree_hash|
      new(degree_hash).load
    end
  end

  def initialize(degree_hash)
    @degree_hash = degree_hash
    @degree_id = degree_hash[:id]
    @degree_dir = BASE_DIR.join(degree_id)
  end

  def load
    load_degree
    load_subject_groups
    load_subjects
    load_prerequisites
    load_current_optional_subjects
    TreePreloader.break_cache!
  end

  private

  attr_reader :degree_hash
  attr_reader :degree_id
  attr_reader :degree_dir
  attr_reader :degree

  def load_degree
    @degree = Degree.find_or_initialize_by(id: degree_id)
    @degree.current_plan = degree_hash[:current_plan]
    @degree.include_inco_subjects = degree_hash[:include_inco_subjects]
    @degree.save!
  end

  def load_subject_groups
    subject_groups = safe_read_yaml(degree_dir.join("scraped_subject_groups.yml"))
    subject_groups.each do |code, yml_group|
      subject_group = degree.subject_groups.find_or_initialize_by(code:)
      subject_group.name = format_name(yml_group["name"])
      subject_group.credits_needed = yml_group["min_credits"]
      subject_group.save!
    end
  end

  def load_subjects
    subjects = safe_read_yaml(degree_dir.join("scraped_subjects.yml"))
    subjects_overrides = safe_read_yaml(degree_dir.join("subject_overrides.yml"))

    subjects.each do |code, subject|
      new_subject = degree.subjects.find_or_initialize_by(code:)

      new_subject.name = format_name(subject["name"])
      new_subject.credits = subject["subject_groups"].sum { |group| group["credits"] }
      group_code = subject["subject_groups"].last&.dig("group")
      new_subject.group = degree.subject_groups.find_by(code: group_code)

      subject_overrides = subjects_overrides[code] || {}
      new_subject.eva_id = subject_overrides['eva_id']
      new_subject.second_semester_eva_id = subject_overrides['second_semester_eva_id']
      new_subject.openfing_id = subject_overrides['openfing_id']
      new_subject.short_name = subject_overrides['short_name']
      new_subject.category = subject_overrides['category'] || 'optional'

      new_subject.save!

      new_subject.create_course! unless new_subject.course

      if subject["has_exam"]
        new_subject.create_exam! unless new_subject.exam
      else
        raise "Subject #{code} no longer has an exam" if new_subject.exam
      end
    end
  end

  # rubocop:disable Rails/SkipsModelValidations
  def load_current_optional_subjects
    optional_subject_codes = safe_read_yaml(degree_dir.join("scraped_optional_subjects.yml"), default: [])
    Subject.transaction do
      degree.subjects.where(code: optional_subject_codes).update_all(current_optional_subject: true)
      degree.subjects.where.not(code: optional_subject_codes).update_all(current_optional_subject: false)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations

  def load_prerequisites
    prerequisites = safe_read_yaml(degree_dir.join("scraped_prerequisites.yml"))

    Prerequisite
      .joins(approvable: :subject)
      .where(approvable: { subjects: { degree_id: degree.id } })
      .destroy_all

    prerequisites.each do |prerequisite|
      subject = degree.subjects.find_by(code: prerequisite["subject_code"])
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
      subject = degree.subjects.find_by!(code: prerequisite["subject_needed_code"])

      case prerequisite["needs"]
      when 'exam' then SubjectPrerequisite.new(approvable_needed: subject.exam)
      when 'course' then SubjectPrerequisite.new(approvable_needed: subject.course)
      when 'all' then SubjectPrerequisite.new(approvable_needed: subject.exam || subject.course)
      when 'course_enrollment' then EnrollmentPrerequisite.new(approvable_needed: subject.course)
      when 'exam_enrollment' then EnrollmentPrerequisite.new(approvable_needed: subject.exam)
      when 'exam_activity' then ActivityPrerequisite.new(approvable_needed: subject.exam)
      when 'course_activity' then ActivityPrerequisite.new(approvable_needed: subject.course)
      else raise "Unknown approvable needed: #{prerequisite["needs"]}"
      end

    when 'credits'
      subject_group = prerequisite["group"] ? degree.subject_groups.find_by(code: prerequisite["group"]) : nil
      CreditsPrerequisite.new(credits_needed: prerequisite["credits"], subject_group:)
    else
      raise "Unknown prerequisite type: #{prerequisite["type"]}"
    end
  end

  def safe_read_yaml(path, default: {})
    return default unless File.exist?(path)

    YAML.load_file(path)
  end
end
