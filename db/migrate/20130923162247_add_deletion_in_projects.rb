class AddDeletionInProjects < ActiveRecord::Migration
  def up
    add_column :projects, :delection, :boolean, null: true, default: false
  end

  def down
    remove_column :projects, :delection
  end
end
