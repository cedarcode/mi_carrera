if Rails.env.test?
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  task default: [:rubocop, :eslint, :test, "test:system"]
end
