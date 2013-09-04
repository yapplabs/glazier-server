class SectionSerializer < ActiveModel::Serializer
  attributes :id, :name, :position, :slug, :container_type, :dashboard_id
  has_many :panes, embed: :ids, include: true, key: :pane_ids #, root: :panes
end
