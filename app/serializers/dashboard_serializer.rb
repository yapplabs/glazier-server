class DashboardSerializer < ActiveModel::Serializer
  attribute :repository, key: :id
  has_many :sections, embed: :ids, include: true, key: :section_ids #, root: :sections
end
