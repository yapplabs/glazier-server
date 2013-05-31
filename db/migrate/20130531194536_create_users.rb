class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :github_id
      t.string :github_login
      t.string :email

      t.timestamps
    end

    add_index :users, :github_id, unique: true
  end
end
