class ModifyFieldsForProjects < ActiveRecord::Migration
  def up
    change_column :projects, :exists_test_server, :boolean, { default: false, null: true }
    add_column :projects, :miss, :boolean, { default: false, null: true}
  end

  def down
    change_column :projects, :exists_test_server, :string, { default: nil, null: true }
    remove_column :projects, :miss
  end
end
