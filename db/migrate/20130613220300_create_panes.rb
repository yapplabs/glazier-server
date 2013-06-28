class CreatePanes < ActiveRecord::Migration
  def up
    create_table :panes, id: false do |t|
      t.column :id, :uuid
      t.string :repository
      t.string :pane_type_name, null: false
      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE panes ADD PRIMARY KEY (id);
      ALTER TABLE panes
        ADD CONSTRAINT panes_pane_type_name_fkey FOREIGN KEY (pane_type_name)
            REFERENCES pane_types (name) ON DELETE CASCADE;
      ALTER TABLE panes
        ADD CONSTRAINT panes_repository_fkey FOREIGN KEY (repository)
            REFERENCES dashboards (repository) ON DELETE CASCADE;
    SQL
  end

  def down
    drop_table :dashboards
  end
end
