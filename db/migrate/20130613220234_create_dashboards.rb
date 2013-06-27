class CreateDashboards < ActiveRecord::Migration
  def up
    create_table :dashboards, :id => false do |t|
      t.string :repository
      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE dashboards ADD PRIMARY KEY (repository);
    SQL
  end

  def down
    drop_table :dashboards
  end
end
