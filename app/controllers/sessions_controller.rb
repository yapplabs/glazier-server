require 'services/github'

class SessionsController < ApplicationController
  def create
    github_access_token = params[:github_access_token]
    if github_access_token.blank?
      return render_invalid_github_access_token_json
    end

    github_user_data = Services::Github.get_user(github_access_token)

    user = User.find_or_create(github_access_token, github_user_data)

    sync_repos(user)

    self.current_user = user

    render json: user, status: :created
  rescue => e
    case e
    when Services::Github::InvalidCredentials
      render_invalid_github_access_token_json
    else
      log_fatal(e)
      render_internal_error_json(e)
    end
  end

  def destroy
    cookies.delete(:login)
    head :no_content
  end

  private
  def sync_repos(user)
    user_repos_data = Services::Github.get_user_repos(user.github_access_token)

    user_repos_data.each do |repo_data|
      repository = repo_data['full_name']

      Dashboard.find_or_bootstrap(repository)

      if repo_data['permission']

      end
    end
  end

  def render_invalid_github_access_token_json
    render json: {
      error: 'Invalid github_access_token param'
    }, status: :bad_request
  end
end
