class DashboardSerializer < ActiveModel::Serializer
  attribute :repository, key: :id
  has_many :panes, embed: :ids, include: true, key: :pane_ids, root: :panes
end
