class Pane < ActiveRecord::Base
  has_and_belongs_to_many :dashboards
  belongs_to :card_manifest, :foreign_key => :card_manifest_name
end
