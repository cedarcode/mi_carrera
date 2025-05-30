task backfill_degrees: :environment do
  degrees = Rails.configuration.degrees
  degrees.each do |degree_hash|
    degree = Degree.find_or_initialize_by(key: degree_hash[:key])
    degree.name = degree_hash[:name]
    degree.current_plan = degree_hash[:current_plan]
    degree.include_inco_subjects = degree_hash[:include_inco_subjects]
    degree.save!
  end

  computacion = Degree.find_by(key: "computacion")

  User.find_each { |user| user.update(degree: computacion) }
  Subject.find_each { |subject| subject.update(degree: computacion) }
  SubjectGroup.find_each { |subject_group| subject_group.update(degree: computacion) }
end
