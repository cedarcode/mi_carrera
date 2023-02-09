class Users::SessionsController < Devise::SessionsController
  after_action :remove_approvables_in_cookies, only: [:create, :destroy]
end
