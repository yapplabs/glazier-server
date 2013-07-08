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

  # Updates local dashboard info based on current Github edit rights
  def sync_repos(user)
    user_repos_data = Services::Github.get_user_repos(user.github_access_token)
    syncer = UserDashboardSyncer.new(user, user_repos_data)
    syncer.create_missing_dashboards
    syncer.remove_outdated_dashboards
  end

  def render_invalid_github_access_token_json
    render json: {
      error: 'Invalid github_access_token param'
    }, status: :bad_request
  end
end
