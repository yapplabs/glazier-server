# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActiveRecord::Base.transaction do
  issues_pane_type = PaneType.create do |pane_type|
    pane_type.name = 'glazier-github-issues'
    pane_type.url = 'http://localhost:8000/cards/glazier-github-issues/manifest.json'
    pane_type.manifest = ActiveSupport::JSON.encode(
      cardUrl: '/cards/glazier-github-issues/card.js',
      consumes: [ 'repository', 'authenticatedGithubApi', 'unauthenticatedGithubApi', 'identity' ]
    )
  end

  stars_pane_type = PaneType.create do |pane_type|
    pane_type.name = 'glazier-github-stars'
    pane_type.url = 'http://localhost:8000/cards/glazier-github-stars/manifest.json'
    pane_type.manifest = ActiveSupport::JSON.encode(
      cardUrl: '/cards/glazier-github-stars/card.js',
      consumes: [ 'repository', 'unauthenticatedGithubApi', 'authenticatedGithubApi', 'identity' ]
    )
  end

  Dashboard.create do |dashboard|
    dashboard.repository = 'emberjs/ember.js'

    dashboard.panes << Pane.create do |pane|
      pane.id = 'c37b0ba4-cecc-11e2-8fa4-ef3e5db78e4d'
      pane.pane_type = issues_pane_type
    end

    dashboard.panes << Pane.create do |pane|
      pane.id = 'e66028d8-d477-11e2-ac68-97cedea43709'
      pane.pane_type = stars_pane_type
    end
  end

  Dashboard.create do |dashboard|
    dashboard.repository = 'yapplabs/glazier'

    dashboard.panes << Pane.create do |pane|
      pane.id = 'dca13978-cecc-11e2-b9e3-e342ecfc2ff7'
      pane.pane_type = issues_pane_type
    end

    dashboard.panes << Pane.create do |pane|
      pane.id = 'f1274314-d477-11e2-9e9a-9f78f0c9dfa7'
      pane.pane_type = stars_pane_type
    end
  end

end
