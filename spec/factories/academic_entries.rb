FactoryBot.define do
  factory :academic_entry, class: 'Transcript::AcademicEntry' do
    name { 'Test Subject' }
    credits { '10' }
    number_of_failures { '0' }
    date_of_completion { '20/02/2024' }
    grade { 'Aceptable' }

    trait :failed do
      name { 'Failed Subject' }
      credits { '10' }
      number_of_failures { '1' }
      date_of_completion { '**********' }
      grade { '***' }
    end
  end
end
