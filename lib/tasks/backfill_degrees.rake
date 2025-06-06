task backfill_degrees: :environment do
  ActiveRecord::Base.transaction do
    degree_hash = {
      title: "INGENIERIA EN COMPUTACION",
      name: "computacion",
      current_plan: "1997",
      include_inco_subjects: true
    }

    degree = Degree.find_or_initialize_by(name: degree_hash[:name])
    degree.title = degree_hash[:title]
    degree.current_plan = degree_hash[:current_plan]
    degree.include_inco_subjects = degree_hash[:include_inco_subjects]
    degree.save!

    computacion = Degree.find_by!(name: "computacion")

    User.find_each { |user| user.update!(degree: computacion) }
    Subject.find_each { |subject| subject.update!(degree: computacion) }
    SubjectGroup.find_each { |subject_group| subject_group.update!(degree: computacion) }
  end
end
