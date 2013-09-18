class AddFieldsInProjects < ActiveRecord::Migration
  def up
    add_column :projects, :year_migrate, :boolean, { default: false, null: true }
    add_column :projects, :server_update, :boolean, { default: false, null: true }
    add_column :projects, :registration_status, :boolean, { default: false, null: true }
  end

  def down
    remove_column :projects, :year_migrate
    remove_column :projects, :server_update
    remove_column :projects, :registration_status
  end
end
