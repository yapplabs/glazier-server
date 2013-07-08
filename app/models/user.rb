class User < ActiveRecord::Base
  self.primary_key = :github_id

  has_many :user_dashboards, foreign_key: :github_id, dependent: :delete_all
  has_many :dashboards, through: :user_dashboards

  def self.find_or_create(github_access_token, github_user_data)
    github_id = github_user_data.fetch('id')

    user = User.where(github_id: github_id).first

    return user if user

    User.create! do |user|
      user.github_id = github_id
      user.github_access_token = github_access_token
      user.github_login = github_user_data.fetch('login')
      user.email = github_user_data.fetch('email')
      user.name = github_user_data['name']
      user.gravatar_id = github_user_data['gravatar_id']
    end
  end
end
