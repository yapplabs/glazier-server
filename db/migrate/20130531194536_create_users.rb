class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :id => false do |t|
      t.integer :github_id, :limit => 8
      t.text    :github_access_token
      t.text    :github_login
      t.text    :name
      t.text    :email
      t.text    :gravatar_id

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE users ADD PRIMARY KEY (github_id);
    SQL
  end
end
