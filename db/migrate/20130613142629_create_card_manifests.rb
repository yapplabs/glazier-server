class CreateCardManifests < ActiveRecord::Migration
  def up
    create_table :card_manifests, id: false do |t|
      t.string :name
      t.string :url
      t.text :manifest

      t.timestamps
    end

    execute "ALTER TABLE card_manifests ADD PRIMARY KEY (name);"
  end

  def down
    drop_table :card_manifests
  end
end
