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

    session[:user_id] = user.github_id

    render json: user
  end

  def destroy
    session[:user_id] = nil
  end
end
