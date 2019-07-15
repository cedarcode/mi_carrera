# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

class StudentAppSeeder
  def seed
    Prerequisite.all.delete_all
    subject_groups = populate_subject_groups!
    populate_subjects!(subject_groups)
  end

  def populate_subject_groups!
    seed_filepath = Rails.root.join('db', 'seeds', 'subject_groups.yml')
    File.open(seed_filepath) do |file|
      subject_groups = YAML.load_file(file)
      subject_groups.keys.sort.each do |key|
        group_data = subject_groups[key]
        populate_subject_group!(group_data)
      end
      subject_groups
    end
  end

  def populate_subject_group!(group_data)
    group = SubjectGroup.where(code: group_data["code"]).first_or_create
    group.update!(name: group_data["name"])
  end

  def populate_subjects!(subject_groups)
    seed_filepath = Rails.root.join('db', 'seeds', 'subjects.yml')
    File.open(seed_filepath) do |file|
      subjects = YAML.load_file(file)
      subjects.keys.sort.each do |key|
        subject_data = subjects[key]
        populate_subject_with_dependencies!(subject_data, subjects, subject_groups)
      end
    end
  end

  def populate_subject!(data, subject_groups)
    subject = Subject.where(code: data["code"]).first_or_create
    group_key = data["group"]
    group = SubjectGroup.where(code: subject_groups[group_key]["code"]).first
    subject.update!(
      name: data["name"],
      credits: data["credits"],
      semester: data["semester"],
      short_name: data["short_name"],
      group_id: group.id
    )
    if subject.course.nil?
      subject.create_course!
    end
    if data["has_exam"]
      if subject.exam.nil?
        subject.create_exam!
      end
    end
    subject
  end

  def populate_subject_with_dependencies!(data, subjects, subject_groups)
    subject = populate_subject!(data, subject_groups)
    if data["course-needs"]
      populate_prerequisites_tree!(subject.course, data["course-needs"], subjects, subject_groups)
    end
    if data["has_exam"]
      if data["exam-needs"]
        populate_prerequisites_tree!(subject.exam, data["exam-needs"], subjects, subject_groups)
      end
    end
    subject
  end

  def populate_prerequisites_tree!(root, prerequisites, subjects, subject_groups)
    prerequisites.each do |prerequisite|
      if prerequisite.key?("subject")
        add_subject_prerequisite(
          root,
          prerequisite["subject"],
          prerequisite["type"],
          subjects,
          subject_groups
        )
      elsif prerequisite.key?("credits")
        add_credits_prerequisite(
          root,
          prerequisite["credits"],
          prerequisite["amount"],
          subject_groups
        )
      elsif prerequisite.keys & LogicalPrerequisite::LOGICAL_OPERATORS != []
        add_logical_prerequisite(
          root,
          prerequisite.keys.first,
          prerequisite[prerequisite.keys.first],
          subjects,
          subject_groups
        )
      end
    end
  end

  def add_subject_prerequisite(parent, subject_key, type, subjects, subject_groups)
    dependency = populate_subject!(subjects[subject_key], subject_groups)

    case parent
    when Approvable
      if type == "course"
        SubjectPrerequisite
          .where(approvable_id: parent.id, approvable_needed_id: dependency.course.id)
          .first_or_create!
      elsif type == "exam"
        SubjectPrerequisite
          .where(approvable_id: parent.id, approvable_needed_id: dependency.exam.id)
          .first_or_create!
      end
    when Prerequisite
      if type == "course"
        SubjectPrerequisite
          .where(parent_prerequisite_id: parent.id, approvable_needed_id: dependency.course.id)
          .first_or_create!
      elsif type == "exam"
        SubjectPrerequisite
          .where(parent_prerequisite_id: parent.id, approvable_needed_id: dependency.exam.id)
          .first_or_create!
      end
    end
  end

  def add_credits_prerequisite(parent, group_key, credits, subject_groups)
    case parent
    when Approvable
      if group_key == "total"
        CreditsPrerequisite
          .where(approvable_id: parent.id, subject_group_id: nil, credits_needed: credits)
          .first_or_create!
      else
        group = SubjectGroup.where(code: subject_groups[group_key]["code"]).first
        CreditsPrerequisite
          .where(approvable_id: parent.id, subject_group_id: group.id, credits_needed: credits)
          .first_or_create!
      end
    when Prerequisite
      if group_key == "total"
        CreditsPrerequisite
          .where(parent_prerequisite_id: parent.id, subject_group_id: nil, credits_needed: credits)
          .first_or_create!
      else
        group = SubjectGroup.where(code: subject_groups[group_key]["code"]).first
        CreditsPrerequisite
          .where(parent_prerequisite_id: parent.id, subject_group_id: group.id, credits_needed: credits)
          .first_or_create!
      end
    end
  end

  def add_logical_prerequisite(parent, logical_operator, prerequisites, subjects, subject_groups)
    case parent
    when Approvable
      prerequisite = LogicalPrerequisite
                     .create!(approvable_id: parent.id, logical_operator: logical_operator)
    when Prerequisite
      prerequisite = LogicalPrerequisite
                     .create!(parent_prerequisite_id: parent.id, logical_operator: logical_operator)
    end

    populate_prerequisites_tree!(prerequisite, prerequisites, subjects, subject_groups)
  end
end

StudentAppSeeder.new.seed
