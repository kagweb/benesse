class AddDeletionInProjects < ActiveRecord::Migration
  def up
    add_column :projects, :deletion, :boolean, null: true, default: false
  end

  def down
    remove_column :projects, :deletion
  end
end
