class CreateDashboards < ActiveRecord::Migration
  def up
    create_table :dashboards, :id => false do |t|
      t.string :repository
      t.timestamps
    end

    create_table :dashboards_panes, :id => false do |t|
      t.string :repository
      t.column :pane_id, :uuid
    end

    execute <<-SQL
      ALTER TABLE dashboards ADD PRIMARY KEY (repository);
      ALTER TABLE dashboards_panes ADD PRIMARY KEY (repository, pane_id);
      ALTER TABLE dashboards_panes
        ADD CONSTRAINT dashboards_panes_repository_fkey FOREIGN KEY (repository)
            REFERENCES dashboards (repository);
      ALTER TABLE dashboards_panes
        ADD CONSTRAINT dashboards_panes_pane_id_fkey FOREIGN KEY (pane_id)
            REFERENCES panes (id);
    SQL
  end

  def down
    drop_table :dashboards
  end
end
