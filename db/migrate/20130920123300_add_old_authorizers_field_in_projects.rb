class AddOldAuthorizersFieldInProjects < ActiveRecord::Migration
  def up
    add_column :projects, :old_authorizer_id, :integer, { default: nil, null: true }
    add_column :projects, :old_promoter_id,   :integer, { default: nil, null: true }
  end

  def down
    remove_column :projects, :old_authorizer_id
    remove_column :projects, :old_promoter_id
  end
end
