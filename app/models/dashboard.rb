require 'services/github'

class Dashboard < ActiveRecord::Base
  self.primary_key = :repository

  has_many :sections, order: 'position', dependent: :delete_all

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

  def add_section(attributes)
    sections.create! do |section|
      section.id = attributes[:id]
      section.name = attributes[:name]
      section.slug = attributes[:slug]
      section.container_type = attributes[:container_type]
      section.position = attributes[:position]
    end
  end

  def self.bootstrap(repository)
    transaction(requires_new: true) do
      create! do |dashboard|
        dashboard.repository = repository
        section = Section.create! do |section|
          section.name = 'Overview'
          section.slug = 'overview'
          section.container_type = 'board'
          section.position = 0
          section.dashboard = dashboard
          DEFAULT_PANE_TYPE_NAMES.map do |pane_type_name|
            pane = section.panes.new
            pane.pane_type_name = pane_type_name
          end
        end
      end
    end
  rescue ActiveRecord::RecordNotUnique
    find(repository)
  end
end
