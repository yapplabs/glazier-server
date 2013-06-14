class Dashboard < ActiveRecord::Base
  self.primary_key = :repository

  has_and_belongs_to_many :panes, foreign_key: :repository
end
