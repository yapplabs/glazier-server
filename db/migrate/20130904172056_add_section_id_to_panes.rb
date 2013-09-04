class AddSectionIdToPanes < ActiveRecord::Migration
  def up
    add_column :panes, :section_id, :uuid, null: true
    execute <<-SQL
      ALTER TABLE panes
        ADD CONSTRAINT panes_section_id_fkey FOREIGN KEY (section_id)
            REFERENCES sections (id) ON DELETE CASCADE;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE panes DROP CONSTRAINT panes_section_id_fkey;
    SQL
    remove_column :panes, :section_id
  end
end
