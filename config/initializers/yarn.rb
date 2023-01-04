# Ensure JS packages up to date when starting Rails server in development
if Rails.env.development? && Rails.const_defined?('Server')
  system("bin/yarn install --check-files") || exit(1)
end
