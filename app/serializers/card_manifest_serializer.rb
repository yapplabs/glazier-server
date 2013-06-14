class CardManifestSerializer < ActiveModel::Serializer
  attribute :name, key: :id
  attributes :manifest, :url
end
