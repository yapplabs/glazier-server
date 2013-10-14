class ShallowDashboardSerializer < ActiveModel::Serializer
  attribute :repository, key: :id
  has_many :sections, embed: :ids, include: false, key: :section_ids #, root: :sections
end
