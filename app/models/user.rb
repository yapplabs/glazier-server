class User < ActiveRecord::Base
  attr_accessible :github_id, :github_login, :email
end
