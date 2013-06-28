class CreatePaneTypes < ActiveRecord::Migration
  def up
    create_table :pane_types, id: false do |t|
      t.string :name
      t.string :url, null: false
      t.text   :manifest, null: false

      t.timestamps
    end

    execute "ALTER TABLE pane_types ADD PRIMARY KEY (name);"
  end

  def down
    drop_table :pane_types
  end
end
