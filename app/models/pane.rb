class Pane < ActiveRecord::Base
  belongs_to :dashboard, :foreign_key => :repository
  belongs_to :card_manifest, :foreign_key => :card_manifest_name

  before_create :ensure_id

  def ensure_id
    self.id = SecureRandom.uuid if id.blank?
  end
end
