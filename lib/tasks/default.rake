if Rails.env.test?
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  task(:default).clear
  task default: [:rubocop, :test, "test:system"]
end
