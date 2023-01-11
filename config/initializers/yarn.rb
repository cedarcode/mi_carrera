# Ensure JS packages up to date when starting Rails server in development
if Rails.env.development? && Rails.const_defined?('Server')
  raise "Error installing yarn packages" unless system("bin/yarn install --check-files")
end
