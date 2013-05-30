class CreateCardEntries < ActiveRecord::Migration
  def change
    create_table :card_entries do |t|
      t.column :card_id, :uuid
      t.column :user_id, :uuid
      t.string :access
      t.string :key
      t.text :value

      t.timestamps
    end

    add_index :card_entries, [:card_id, :user_id]
  end
end
