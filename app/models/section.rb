class Section < ActiveRecord::Base
  belongs_to :dashboard
  has_many :panes, order: 'position', dependent: :delete_all

  before_create :ensure_id
  before_destroy :prevent_destroy_of_last_section

  attr_accessible :dashboard_id, :name, :position, :slug, :type

  def add_pane(name, id = nil, position = nil, repository = nil)
    panes.create! do |pane|
      pane.id = id if id
      pane.pane_type_name = name
      pane.position = position || next_pane_position
      pane.repository = repository
    end
  end

  def next_pane_position
    panes.max { |a,b| a.position || 0 <=> b.position || 0 }
  end

  def pane_names
    panes.map do |pane|
      pane.pane_type_name
    end
  end

  def remove_pane(name)
    panes.where(pane_type_name: name).destroy_all
  end

  def ensure_id
    self.id = SecureRandom.uuid if id.blank?
  end

  protected

  def prevent_destroy_of_last_section
    return false unless dashboard.sections.count > 1
  end
end
