class Pane < ActiveRecord::Base
  has_and_belongs_to_many :dashboards
  belongs_to :card_manifest, :foreign_key => :card_manifest_name

  before_create :ensure_id

  def ensure_id
    self.id = SecureRandom.uuid if id.blank?
  end
end
