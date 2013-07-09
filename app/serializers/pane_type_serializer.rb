class PaneTypeSerializer < ActiveModel::Serializer
  attribute :name, key: :id
  attributes :manifest, :url
end
