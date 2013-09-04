class PopulateSectionIds < ActiveRecord::Migration
  class Pane < ActiveRecord::Base; end
  class Section < ActiveRecord::Base; end

  def up
    Section.all.each do |section|
      Pane.where(dashboard_id: section.dashboard_id).each do |pane|
        pane.update_column(:section_id, section.id)
      end
    end
  end

  def down
  end
end
