require 'services/github'

class Dashboard < ActiveRecord::Base
  self.primary_key = :repository

  has_many :panes, order: 'position', dependent: :delete_all

  has_many :user_dashboards, foreign_key: :repository, dependent: :delete_all
  has_many :users, through: :user_dashboards

  DEFAULT_PANE_TYPE_NAMES = [
    'glazier-github-issues',
    'glazier-github-stars'
  ]

  def self.find_or_bootstrap(repository)
    dashboard = where(repository: repository).first

    return dashboard if dashboard.present?

    bootstrap(repository)
  end

  def self.bootstrap(repository)
    transaction(requires_new: true) do
      create! do |dashboard|
        dashboard.repository = repository
        DEFAULT_PANE_TYPE_NAMES.map do |pane_type_name|
          pane = dashboard.panes.new
          pane.pane_type_name = pane_type_name
        end
      end
    end
  rescue ActiveRecord::RecordNotUnique
    find(repository)
  end

  def add_pane(name, id = nil, position = nil)
    panes.create! do |pane|
      pane.id = id if id
      pane.pane_type_name = name
      pane.position = position || next_pane_position
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
end
