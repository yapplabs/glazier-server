class CreateCardEntries < ActiveRecord::Migration
  def change
    create_table :card_entries do |t|
      t.column :card_id, :uuid, null: false
      t.text :access, null: false
      t.integer :github_id, :limit => 8
      t.text :key
      t.text :value
      t.timestamps
    end

    add_index :card_entries, [:card_id, :access, :github_id, :key], unique: true
  end
end
