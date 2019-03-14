# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

class StudentAppSeeder
  def seed
    subjects_groups = populate_subjects_groups!
    populate_subjects!(subjects_groups)
  end

  def populate_subjects_groups!
    seed_filepath = Rails.root.join('db', 'seeds', 'subjects_groups.yml')
    File.open(seed_filepath) do |file|
      subjects_groups = YAML.load_file(file)
      subjects_groups.keys.sort.each do |key|
        group_data = subjects_groups[key]
        populate_subjects_group!(group_data)
      end
      subjects_groups
    end
  end

  def populate_subjects_group!(group_data)
    SubjectsGroup.where(name: group_data["name"]).first_or_create
  end

  def populate_subjects!(subjects_groups)
    seed_filepath = Rails.root.join('db', 'seeds', 'subjects.yml')
    File.open(seed_filepath) do |file|
      subjects = YAML.load_file(file)
      subjects.keys.sort.each do |key|
        subject_data = subjects[key]
        populate_subject_with_dependencies!(subject_data, subjects, subjects_groups)
      end
    end
  end

  def populate_subject!(data, subjects_groups)
    subject = Subject.where(name: data["name"]).first_or_create
    group_key = data["group"]
    group = SubjectsGroup.where(name: subjects_groups[group_key]["name"]).first
    subject.update!(
      credits: data["credits"],
      semester: data["semester"],
      short_name: data["short_name"],
      group_id: group.id
    )
    if subject.course.nil?
      subject.create_course
    end
    if data["has_exam"]
      if subject.exam.nil?
        subject.create_exam
      end
    end
    subject
  end

  def populate_subject_with_dependencies!(data, subjects, subjects_groups)
    subject = populate_subject!(data, subjects_groups)
    if data["course-needs"]
      populate_prerequisites!(subject.course, data["course-needs"], subjects, subjects_groups)
    end
    if data["has_exam"]
      if data["exam-needs"]
        populate_prerequisites!(subject.exam, data["exam-needs"], subjects, subjects_groups)
      end
    end
    subject
  end

  def populate_prerequisites!(dependency_item, prerequisites, subjects, subjects_groups)
    prerequisites.each do |prerequisite|
      if prerequisite["subject"]
        add_subject_prerequisites(
          dependency_item,
          prerequisite["subject"],
          prerequisite["type"],
          subjects,
          subjects_groups
        )
      elsif prerequisite["credits"]
        add_credits_prerequisites(
          dependency_item,
          prerequisite["credits"],
          prerequisite["amount"],
          subjects_groups
        )
      end
    end
  end

  def add_subject_prerequisites(dependency_item, subject_key, type, subjects, subjects_groups)
    dependency = populate_subject!(subjects[subject_key], subjects_groups)
    if type == "course"
      Dependency.where(dependency_item_id: dependency_item.id, prerequisite_id: dependency.course.id).first_or_create
    elsif type == "exam"
      Dependency.where(dependency_item_id: dependency_item.id, prerequisite_id: dependency.exam.id).first_or_create
    end
  end

  def add_credits_prerequisites(dependency_item, group_key, credits, subjects_groups)
    if group_key == "total"
      create_credits_prerequisite(dependency_item, credits)
    else
      group = SubjectsGroup.where(name: subjects_groups[group_key]["name"]).first
      create_credits_prerequisite(dependency_item, group.id, credits)
    end
  end

  def create_credits_prerequisite(dependency_item, group_id = nil, credits)
    CreditsPrerequisite.where(
      dependency_item_id: dependency_item.id,
      subjects_group_id: group_id
    ).first_or_create(credits_needed: credits)
  end
end

StudentAppSeeder.new.seed
