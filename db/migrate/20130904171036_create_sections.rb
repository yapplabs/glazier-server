class CreateSections < ActiveRecord::Migration
  def up
    create_table :sections, id: false do |t|
      t.column :id, :uuid
      t.string :dashboard_id
      t.string :name
      t.string :slug
      t.integer :position
      t.string :container_type

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE sections ADD PRIMARY KEY (id);
      ALTER TABLE sections
        ADD CONSTRAINT sections_dashboard_id_fkey FOREIGN KEY (dashboard_id)
            REFERENCES dashboards (repository) ON DELETE CASCADE;
    SQL
  end

  def down
    drop_table :sections
  end
end
