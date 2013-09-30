class AddUploadedToProjects < ActiveRecord::Migration
  def up
    add_column :projects, :uploaded, :boolean, null: true, default: false
  end

  def down
    remove_column :projects, :uploaded
  end

end
