class CreatePanes < ActiveRecord::Migration
  def up
    create_table :panes, :id => false do |t|
      t.column :id, :uuid
      t.string :card_manifest_name, null: false
      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE panes ADD PRIMARY KEY (id);
      ALTER TABLE panes
        ADD CONSTRAINT panes_card_manifest_name_fkey FOREIGN KEY (card_manifest_name)
            REFERENCES card_manifests (name);
    SQL
  end

  def down
    drop_table :dashboards
  end
end
