class UserDashboardSyncer
  def initialize(user, user_repos_data)
    @user = user
    @user_repos_data = user_repos_data
  end

  def create_missing_dashboards
    need_creation = editable_repository_names.select{|repository|
      !user_dashboards.detect{ |ud| ud.dashboard.repository == repository }
    }
    need_creation.each do |repository|
      dashboard = Dashboard.find_or_bootstrap(repository)
      UserDashboard.create! do |user_dashboard|
        user_dashboard.user = @user
        user_dashboard.dashboard = dashboard
      end
    end
  end

  def remove_outdated_dashboards
    needs_deletion = user_dashboards.select{|dashboard|
      !editable_repository_names.include?(dashboard.repository)
    }
    needs_deletion.each(&:destroy)
  end

private

  def editable_repository_names
    @editable_repository_names ||= begin
      @user_repos_data.select{ |repo_data|
        repo_data['permissions'] && repo_data['permissions']['push']
      }.map{ |repo_data|
        repo_data['full_name']
      }
    end
  end

  def user_dashboards
    @user_dashboards ||= @user.user_dashboards.all
  end
end
