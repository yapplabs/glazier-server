require 'services/github'

class SessionsController < ApplicationController
  def create
    if params[:github_access_token].blank?
      raise "please provide a github_access_token"
    end

    github_access_token = params.fetch(:github_access_token)
    user_data = Services::Github.get_user_data(github_access_token)
    user = User.find_by_github_id(user_data.fetch('id').to_s)

    if !user
      user = User.create! do |u|
        u.github_id = user_data.fetch('id').to_s
        u.github_access_token = github_access_token
        u.github_login = user_data.fetch('login')
        u.name = user_data['name']
        u.email = user_data.fetch('email')
        u.gravatar_id = user_data['gravatar_id']
      end
    end

    serializable_hash = UserSerializer.new(user).serializable_hash
    user_json = ActiveSupport::JSON.encode(serializable_hash)

    # needs to be readable from JS for github XHR
    # TODO cookie should be secure => true in production and have a domain
    cookies.permanent.signed[:login] = user_json

    render json: serializable_hash
  end

  def destroy
    cookies.delete(:login)
  end
end
