require 'services/github'
require 'user_dashboard_syncer'

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
  end

  def destroy
    cookies.delete(:login)
    head :no_content
  end

  private

  def rescue_with_handler(e)
    case e
    when Services::Github::InvalidCredentials
      render_invalid_github_access_token_json
    else
      log_fatal(e)
      render_internal_error_json(e)
    end
  end

  # Updates local dashboard info based on current Github edit rights
  # TODO: should be a background job
  def sync_repos(user)
    repos = Services::Github.get_public_repos_with_push_permission(user.github_access_token)
    user.sync_dashboards(repos)
  end

  def render_invalid_github_access_token_json
    render json: {
      error: 'Invalid github_access_token param'
    }, status: :bad_request
  end
end
