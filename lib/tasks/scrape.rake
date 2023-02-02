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
      subject_group.name = group[:name].split.map(&:capitalize).join(' ')
      subject_group.save!
    end

    # # then create/update all subjects

    subjects.each do |_code, subject|
      puts "Updating subject #{subject[:code]}"
      subject_group = SubjectGroup.find_by(code: subject[:subject_group])
      new_subject = Subject.find_or_initialize_by(code: subject[:code])

      # capitalize only the first letter of words
      new_subject.name = subject[:name].split.map(&:capitalize).join(' ')
      new_subject.credits = subject[:credits]

      new_subject.group = subject_group
      subject_group.subjects << new_subject

      # create the approvables
      if new_subject.exam.nil?
        new_subject.exam = Approvable.new(subject: new_subject, is_exam: true)
      end

      if new_subject.course.nil?
        new_subject.course = Approvable.new(subject: new_subject, is_exam: false)
      end

      subject_group.save!
      new_subject.save!
    end

    # destroy all prerequisites
    Prerequisite.destroy_all

    prerequisites[:prerequisites].each do |prerequisite|
      # byebug
      puts "Updating prerequisite of subject #{prerequisite[:subject_code]}, is_exam: #{prerequisite[:is_exam]}"
      subject = Subject.find_by(code: prerequisite[:subject_code])
      approvable = Approvable.find_or_initialize_by(subject: subject, is_exam: prerequisite[:is_exam])
      approvable.prerequisite_tree = prerequisite_tree(prerequisite, approvable, nil)
      approvable.save!
      if prerequisite[:is_exam]
        subject.exam = approvable
      else
        subject.course = approvable
      end
      subject.save!
    end
  end
end

def prerequisite_tree(prerequisite, approvable, parent_prerequisite)
  case prerequisite[:type]
  when 'logical'
    logical_prerequisite = LogicalPrerequisite.new(approvable: approvable, parent_prerequisite: parent_prerequisite)
    logical_prerequisite.logical_operator = prerequisite[:logical_operator]

    prerequisite[:operands].each do |prerequisite_op|
      operand = prerequisite_tree(prerequisite_op, nil, logical_prerequisite)
      if operand
        logical_prerequisite.operands_prerequisites << operand
      end
    end

    logical_prerequisite.save!
    logical_prerequisite
  when 'subject'

    subject_prerequisite = SubjectPrerequisite.new(approvable: approvable, parent_prerequisite: parent_prerequisite)
    subject = Subject.find_by(code: prerequisite[:subject_needed])

    return nil if subject.nil? # if a subject which isn't in the system is required me don't add that prerequisite

    if prerequisite[:needs] == 'course'
      subject_prerequisite.approvable_needed = Approvable.find_by(subject: subject, is_exam: false)
    else
      subject_prerequisite.approvable_needed = Approvable.find_by(subject: subject, is_exam: true)
    end

    subject_prerequisite.save!
    subject_prerequisite
  when 'credits'

    credits_prerequisite = CreditsPrerequisite.new(approvable: approvable, parent_prerequisite: parent_prerequisite)
    credits_prerequisite.credits_needed = prerequisite[:credits]

    if prerequisite[:group]
      subject_group = SubjectGroup.find_by(code: prerequisite[:group])
      credits_prerequisite.subject_group = subject_group
    end

    credits_prerequisite.save!
    credits_prerequisite
  else
    raise "Unknown prerequisite type: #{prerequisite[:type]}"
  end
end
