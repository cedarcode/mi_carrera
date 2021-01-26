class AuthenticatedController < ApplicationController
  before_action :authenticate
end
