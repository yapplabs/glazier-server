class CreateUserDashboards < ActiveRecord::Migration
  def up
    create_table :user_dashboards, id: false do |t|
      t.integer :github_id, limit: 8
      t.string :repository
      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE user_dashboards ADD PRIMARY KEY (github_id, repository);
      ALTER TABLE user_dashboards
        ADD CONSTRAINT user_dashboards_github_id_fkey FOREIGN KEY (github_id)
            REFERENCES users (github_id) ON DELETE CASCADE;
      ALTER TABLE user_dashboards
        ADD CONSTRAINT user_dashboards_repository_fkey FOREIGN KEY (repository)
            REFERENCES dashboards (repository) ON DELETE CASCADE;
    SQL
  end

  def down
    drop_table :user_dashboards
  end
end
