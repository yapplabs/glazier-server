class AddPositionToPanes < ActiveRecord::Migration
  def change
    add_column :panes, :position, :integer, default: 0
  end
end
