class User < ActiveRecord::Base
  set_primary_key :github_id
  attr_accessible :github_id, :github_login, :email
end
