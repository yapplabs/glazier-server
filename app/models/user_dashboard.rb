class UserDashboard < ActiveRecord::Base
  belongs_to :user, foreign_key: :github_id
  belongs_to :dashboard, foreign_key: :repository
end
