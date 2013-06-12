class UserSerializer < ActiveModel::Serializer
  attributes :github_id, :github_login
end
