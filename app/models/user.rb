class User < ActiveRecord::Base
  self.primary_key = :github_id
  attr_accessible :github_id, :github_login, :email
end
