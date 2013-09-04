class Pane < ActiveRecord::Base
  belongs_to :section
  belongs_to :pane_type, foreign_key: :pane_type_name

  has_many :pane_entries, dependent: :delete_all

  # pane_user_entries.where(:github_id => current_user.github_id)
  has_many :pane_user_entries, dependent: :delete_all

  # pane_type_user_entries.where(:github_id => current_user.github_id)
  has_many :pane_type_user_entries, through: :pane_type

  before_create :ensure_id

  def repository
    read_attribute(:repository).presence || section.try(:dashboard_id)
  end

  def ensure_id
    self.id = SecureRandom.uuid if id.blank?
  end

  def set_entries(data)
    transaction do
      data.each do |key, value|
        set_entry(key, value)
      end
    end
  end

  def set_entry(key, value)
    entry = pane_entries.where(key: key).first
    unless entry
      entry = pane_entries.new
      entry.key = key
    end
    entry.value = value
    entry.save
  end

  def remove_entry(key)
    entry = pane_entries.where(key: key).first
    entry.destroy if entry
  end

  def set_user_entries(github_id, data)
    transaction do
      data.each do |key, value|
        set_user_entry(github_id, key, value)
      end
    end
  end

  def set_user_entry(github_id, key, value)
    entry = pane_user_entries.where(github_id: github_id, key: key).first
    unless entry
      entry = pane_user_entries.new
      entry.github_id = github_id
      entry.key = key
    end
    entry.value = value
    entry.save
  end

  def remove_user_entry(github_id, key)
    entry = pane_user_entries.where(github_id: github_id, key: key).first
    entry.destroy if entry
  end
end
