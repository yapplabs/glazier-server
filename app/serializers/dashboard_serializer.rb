class DashboardSerializer < ActiveModel::Serializer
  attribute :repository
  has_many :panes
end
