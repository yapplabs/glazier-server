class ChangePageTemplatesValueColumnType < ActiveRecord::Migration
  def up
    change_column :page_templates, :value, :text
  end

  def down
    change_column :page_templates, :value, :string
  end
end
