# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

class StudentAppSeeder
  def seed
    seed_filepath = Rails.root.join('db', 'seeds', 'subjects.yml')
    File.open(seed_filepath) do |file|
      doc = YAML.load_file(file)
      doc.keys.sort.each do |subject|
        subject_data = doc[subject]
        populate_subject!(doc, subject_data)
      end
    end
  end

  def populate_subject!(doc, data)
    subject = Subject.where(name: data["name"]).first_or_create
    subject.update!(credits: data["credits"], semester: data["semester"], short_name: data["short_name"])
    if subject.course.nil?
      subject.create_course
      if data["course-needs"]
        populate_prerequisites!(doc, subject.course, data["course-needs"])
      end
    end
    if data["has_exam"]
      if subject.exam.nil?
        subject.create_exam
        if data["exam-needs"]
          populate_prerequisites!(doc, subject.exam, data["exam-needs"])
        end
      end
    end
    subject
  end

  def populate_prerequisites!(doc, dependable, prerequisites)
    prerequisites.each do |prerequisite|
      if prerequisite["subject"]
        dependency = populate_subject!(doc, doc[prerequisite["subject"]])
        if prerequisite["type"] == "course"
          Dependency.where(dependency_item_id: dependable.id, prerequisite_id: dependency.course.id).first_or_create
        elsif prerequisite["type"] == "exam"
          Dependency.where(dependency_item_id: dependable.id, prerequisite_id: dependency.exam.id).first_or_create
        end
      else
        dependable.update!(credits_needed: prerequisite["credits"])
      end
    end
  end
end

StudentAppSeeder.new.seed
