class UserSerializer < ActiveModel::Serializer
  attributes :id, :github_login, :github_id
end
