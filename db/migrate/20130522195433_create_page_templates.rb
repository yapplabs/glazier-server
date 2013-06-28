class CreatePageTemplates < ActiveRecord::Migration
  def change
    create_table :page_templates, id: false do |t|
      t.text :key
      t.text :value

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE page_templates ADD PRIMARY KEY (key);
    SQL
  end
end
