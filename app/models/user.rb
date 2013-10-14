class User < ActiveRecord::Base
  self.primary_key = :github_id

  has_many :user_dashboards, foreign_key: :github_id, dependent: :delete_all
  has_many :dashboards, through: :user_dashboards
  has_many :sections, through: :dashboards
  has_many :pane_user_entries, foreign_key: :github_id, dependent: :delete_all
  has_many :pane_type_user_entries, foreign_key: :github_id, dependent: :delete_all

  def self.find_or_create(github_access_token, github_user_data)
    github_id = github_user_data.fetch('id')

    user = User.where(github_id: github_id).first

    if user
      user.github_access_token = github_access_token
      user.save!
      return user
    end

    User.create! do |user|
      user.github_id = github_id
      user.github_access_token = github_access_token
      user.github_login = github_user_data.fetch('login')
      user.email = github_user_data['email']
      user.name = github_user_data['name']
      user.gravatar_id = github_user_data['gravatar_id']
    end
  end

  def editable_repositories
    dashboards.pluck(:repository)
  end

  def has_dashboard?(repository)
    user_dashboards.where(repository: repository).exists?
  end

  def sync_dashboards(repositories)
    current_repositories = user_dashboards.pluck(:repository)

    repositories_to_delete = current_repositories - repositories

    repositories_to_create = repositories - current_repositories

    user_dashboards.where(UserDashboard.arel_table[:repository].in(repositories_to_delete)).destroy_all

    repositories_to_create.each do |repository|
      dashboard = Dashboard.find_or_bootstrap(repository)
      user_dashboards.create! do |user_dashboard|
        user_dashboard.dashboard = dashboard
      end
    end
  end
end
