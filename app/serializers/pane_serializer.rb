class PaneSerializer < ActiveModel::Serializer
  attribute :id
  has_one :card_manifest, embed: :ids, include: true, key: :card_manifest_id, root: :card_manifests
end
