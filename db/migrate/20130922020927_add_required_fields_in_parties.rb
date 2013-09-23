class AddRequiredFieldsInParties < ActiveRecord::Migration
  def up
    add_column :parties, :aws_confirm_required, :boolean, { default: false, null: true }
    add_column :parties, :test_confirm_required, :boolean, { default: false, null: true }
    add_column :parties, :production_confirm_required, :boolean, { default: false, null: true }
  end

  def down
    remove_column :parties, :aws_confirm_required
    remove_column :parties, :test_confirm_required
    remove_column :parties, :production_confirm_required
  end
end
