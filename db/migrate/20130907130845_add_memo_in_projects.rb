class AddMemoInProjects < ActiveRecord::Migration
  def up
    add_column :projects, :memo, :text, null: true
  end

  def down
    remove_column :projects, :memo
  end
end
