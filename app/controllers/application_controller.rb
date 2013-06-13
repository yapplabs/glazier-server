require 'authentication'

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Authentication
end
