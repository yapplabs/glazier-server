require 'services/github'

class SessionsController < ApplicationController
  def create
    if params[:github_access_token].blank?
      raise "please provide a github_access_token"
    end
    user_data = Services::Github.get_user_data(params.fetch(:github_access_token))
    user = User.find_by_github_id(user_data.fetch('id').to_s)

    if !user
      user = User.create!(
        github_id: user_data.fetch('id').to_s,
        github_login: user_data.fetch('login'),
        email: user_data.fetch('email')
      )
    end

    session[:user_id] = user.id

    render json: user
  end

  def destroy
    session[:user_id] = nil
  end
end
