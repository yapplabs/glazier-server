class CreatePaneEntries < ActiveRecord::Migration
  def change
    create_table :pane_entries do |t|
      t.column :pane_id, :uuid, null: false
      t.text   :key, null: false
      t.text   :value
      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE pane_entries
        ADD CONSTRAINT pane_entries_pane_id_fkey FOREIGN KEY (pane_id)
            REFERENCES panes (id) ON DELETE CASCADE;
      CREATE UNIQUE INDEX pane_entries_pane_id_key_idx
        ON pane_entries (pane_id, key);
    SQL

    create_table :pane_user_entries do |t|
      t.column  :pane_id, :uuid, null: false
      t.integer :github_id, limit: 8, null: false
      t.text    :key, null: false
      t.text    :value
      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE pane_user_entries
        ADD CONSTRAINT pane_user_entries_pane_id_fkey FOREIGN KEY (pane_id)
            REFERENCES panes (id) ON DELETE CASCADE;
      ALTER TABLE pane_user_entries
        ADD CONSTRAINT pane_user_entries_github_id_fkey FOREIGN KEY (github_id)
            REFERENCES users (github_id) ON DELETE CASCADE;
      CREATE UNIQUE INDEX pane_user_entries_pane_id_github_id_key_idx
        ON pane_user_entries (pane_id, github_id, key);
    SQL

    create_table :pane_type_user_entries do |t|
      t.text    :pane_type_name, null: false
      t.integer :github_id, limit: 8, null: false
      t.text    :key, null: false
      t.text    :value
      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE pane_type_user_entries
        ADD CONSTRAINT pane_type_user_entries_pane_type_name_fkey FOREIGN KEY (pane_type_name)
            REFERENCES pane_types (name) ON DELETE CASCADE;
      ALTER TABLE pane_type_user_entries
        ADD CONSTRAINT pane_type_user_entries_github_id_fkey FOREIGN KEY (github_id)
            REFERENCES users (github_id) ON DELETE CASCADE;
      CREATE UNIQUE INDEX pane_type_user_entries_pane_type_name_github_id_key_idx
        ON pane_type_user_entries (pane_type_name, github_id, key);
    SQL
  end
end
