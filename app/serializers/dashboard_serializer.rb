class DashboardSerializer < ActiveModel::Serializer
  attribute :repository, key: :id
  has_many :panes
end
