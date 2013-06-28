class Pane < ActiveRecord::Base
  belongs_to :dashboard, :foreign_key => :repository
  belongs_to :pane_type, :foreign_key => :pane_type_name

  before_create :ensure_id

  def ensure_id
    self.id = SecureRandom.uuid if id.blank?
  end
end
