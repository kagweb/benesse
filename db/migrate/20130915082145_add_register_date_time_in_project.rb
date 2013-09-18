class AddRegisterDateTimeInProject < ActiveRecord::Migration
  def up
    add_column :projects, :register_datetime, :boolean, { default: false, null: true }
  end

  def down
    remove_column :projects, :register_datetime
  end
end
