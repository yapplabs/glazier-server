class PaneSerializer < ActiveModel::Serializer
  attribute :id
  has_one :pane_type, embed: :ids, include: true, key: :pane_type_id, root: :pane_types
end
