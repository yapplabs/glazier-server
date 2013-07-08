class Pane < ActiveRecord::Base
  belongs_to :dashboard, foreign_key: :repository
  belongs_to :pane_type, foreign_key: :pane_type_name

  has_many :pane_entries, dependent: :delete_all

  # pane_user_entries.where(:github_id => current_user.github_id)
  has_many :pane_user_entries, dependent: :delete_all

  # pane_type_user_entries.where(:github_id => current_user.github_id)
  has_many :pane_type_user_entries, through: :pane_type

  before_create :ensure_id

  def ensure_id
    self.id = SecureRandom.uuid if id.blank?
  end
end
