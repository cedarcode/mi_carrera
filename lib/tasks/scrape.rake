namespace :scrape do
  desc "scrape subject groups, subjects and their prerequisites from bedelias.udelar.edu.uy to YAML file"
  task subjects: :environment do
    require 'bedelias_spider'

    BedeliasSpider.new.parse_subjects_and_prerequisites
  end

  desc "reads scraped_subjects.yml, scraped_subject_groups and scraped_prerequisites and if not already " +
    "in database creates them, else it updates them"
  task update_subjects: :environment do
    subject_groups = YAML.load_file(File.join(Rails.root, "db", "seeds", "scraped_subject_groups.yml"))
    subjects = YAML.load_file(File.join(Rails.root, "db", "seeds", "scraped_subjects.yml"))
    prerequisites = YAML.load_file(File.join(Rails.root, "db", "seeds", "scraped_prerequisites.yml"))

    # first create/update all subject groups

    subject_groups.each do |_code, group|
      puts "Updating group #{group[:code]}"
      subject_group = SubjectGroup.find_or_initialize_by(code: group[:code])
      subject_group.name = group[:name]
      subject_group.save!
    end

    # then create/update all subjects

    subjects.each do |_code, subject|
      puts "Updating subject #{subject[:code]}"
      subject_group = SubjectGroup.find_by(code: subject[:subject_group])
      new_subject = Subject.find_or_initialize_by(code: subject[:code])
      new_subject.name = subject[:name]
      new_subject.credits = subject[:credits]

      new_subject.group = subject_group
      subject_group.subjects << new_subject

      subject_group.save!
      new_subject.save!
    end

    # destroy all prerequisites
    Prerequisite.destroy_all

    prerequisites[:prerequisites].each do |prerequisite|
      puts "Updating prerequisite of subject #{prerequisite[:subject_code]}, is_exam: #{prerequisite[:is_exam]}"
      subject = Subject.find_by(code: prerequisite[:subject_code])
      approvable = Approvable.find_or_initialize_by(subject: subject, is_exam: prerequisite[:is_exam])
      approvable.save!
      approvable.prerequisite_tree = prerequisite_tree(prerequisite[:prerequisite])
    end
  end
end

def prerequisite_tree(prerequisite, parent_prerequisite = nil)
  case prerequisite[:type]
  when :logical
    logical_prerequisite = LogicalPrerequisite.initialize_by(approvable: approvable)
    logical_prerequisite.logical_operator = prerequisite[:logical_operator]
    logical_prerequisite.parent_prerequisite = parent_prerequisite

    prerequisite[:operands].each do |prerequisite|
      logical_prerequisite.operands += [
        prerequisite_tree(prerequisite, logical_prerequisite)
      ]
    end

    logical_prerequisite.save!

  when :subject
    subject = Subject.find_by(code: prerequisite[:subject_code])
    approvable = Approvable.find_or_initialize_by(subject: subject, is_exam: prerequisite[:is_exam])
    approvable.save!

    subject_prerequisite = SubjectPrerequisite.initialize_by(approvable: approvable)
    subject_prerequisite.parent_prerequisite = parent_prerequisite
    subject_prerequisite.save!

  when :credits

    credits_prerequisite = CreditsPrerequisite.initialize_by(approvable: nil)
    credits_prerequisite.parent_prerequisite = parent_prerequisite
    credits_prerequisite.credits = prerequisite[:credits]

    if prerequisite[:group]
      subject_group = SubjectGroup.find_by(code: prerequisite[:group])
      credits_prerequisite.subject_group = subject_group
    end

    credits_prerequisite.save!

  end
end
