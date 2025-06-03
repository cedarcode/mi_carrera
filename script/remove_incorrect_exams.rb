require_relative "../config/environment"

subjects_data = YAML.load_file(Rails.root.join("db/data/computacion/scraped_subjects.yml"))
Subject.with_exam.select { |subject| !subjects_data[subject.code]["has_exam"] }.each do |subject|
  destroyed_approvable = subject.exam.destroy!

  User
    .select { |user| user.approvals.include?(destroyed_approvable.id) }
    .each do |user|
      user.approvals.delete(destroyed_approvable.id)
      user.save!
    end
end
