if Rails.env.test? || Rails.env.development?
  task eslint: :environment do
    sh "npx eslint app/javascript/"
  end
end
