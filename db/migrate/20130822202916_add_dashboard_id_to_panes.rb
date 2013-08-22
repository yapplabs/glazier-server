class AddDashboardIdToPanes < ActiveRecord::Migration
  def up
    add_column :panes, :dashboard_id, :string

    Pane.all.each do |pane|
      pane.update_attribute(:dashboard_id, pane.repository)
    end

    execute <<-SQL
      ALTER TABLE panes
        DROP CONSTRAINT panes_repository_fkey;
      ALTER TABLE panes
        ADD CONSTRAINT panes_dashboard_id_fkey FOREIGN KEY (dashboard_id)
            REFERENCES dashboards (repository) ON DELETE CASCADE;
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new
  end
end
