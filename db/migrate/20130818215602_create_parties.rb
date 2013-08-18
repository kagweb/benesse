class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.integer :project_id, :null => false
      t.integer :user_id, :null => false
      t.boolean :required, :null => false, :default => false
      t.boolean :mail_send_to, :null => false, :default => false
      t.boolean :mail_send_cc, :null => false, :default => false

      t.timestamps
    end
  end
end
