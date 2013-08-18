class CreateConfirmations < ActiveRecord::Migration
  def change
    create_table :confirmations do |t|
      t.integer :project_id, :null => false
      t.integer :user_id, :null => false
      t.integer :status, :null => false, :default => 0
      t.string :type, :null => false

      t.timestamps
    end
  end
end
