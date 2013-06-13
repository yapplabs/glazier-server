class UserSerializer < ActiveModel::Serializer
  attributes :github_id, :github_access_token, :github_login, :name, :email, :gravatar_id
end
