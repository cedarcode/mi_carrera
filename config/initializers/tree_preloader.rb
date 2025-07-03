Rails.application.config.after_initialize do
  # we only need to call it with a non empty array
  TreePreloader.preload(Subject.limit(1))
end
