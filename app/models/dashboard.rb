require 'services/github'

class Dashboard < ActiveRecord::Base
  self.primary_key = :repository

  has_many :panes, foreign_key: :repository, dependent: :delete_all

  def self.find_or_bootstrap(repository)
    dashboard = find_by_repository(repository)
    return dashboard if dashboard.present?

    raise ActiveRecord::RecordNotFound unless Services::Github.is_valid_repository?(repository)

    transaction do
      dashboard = create! do |d|
        d.repository = repository
        create_default_panes.each do |pane|
          d.panes << pane
        end
      end
    end
    dashboard
  rescue ActiveRecord::RecordNotUnique
    find_by_repository(repository)
  end

  DEFAULT_CARD_NAMES = [
    'yapplabs/github-issues',
    'yapplabs/github-stars'
  ]
  def self.create_default_panes
    DEFAULT_CARD_NAMES.map do |name|
      Pane.create! do |p|
        p.card_manifest_name = name
      end
    end
  end
end
