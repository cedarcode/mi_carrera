if Rails.env.test? || Rails.env.development?
  task :eslint do
    sh "npx eslint app/javascript/"
  end
end
