class RemoveDashboardIdFromPanes < ActiveRecord::Migration
  def up
    remove_column :panes, :dashboard_id
  end
end
