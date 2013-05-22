class CreatePageTemplates < ActiveRecord::Migration
  def change
    create_table :page_templates do |t|
      t.string :key
      t.string :value

      t.timestamps
    end

    add_index :page_templates, [:key], unique: true
  end
end
