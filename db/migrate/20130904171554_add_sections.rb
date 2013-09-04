class AddSections < ActiveRecord::Migration
  class Dashboard < ActiveRecord::Base; end
  class Section < ActiveRecord::Base; end

  def up
    Dashboard.all.each do |dashboard|
      section = Section.create! do |section|
        section.id = SecureRandom.uuid
        section.dashboard_id = dashboard.repository
        section.name = 'Overview'
        section.slug = 'overview'
        section.position = 0
        section.container_type = 'board'
      end
    end
  end

  def down
  end
end
