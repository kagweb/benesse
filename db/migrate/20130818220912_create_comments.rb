class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :project_id, :null => false
      t.integer :user_id, :null => false
      t.integer :status, :null => false, :default => 0
      t.text :comment, :null => false

      t.timestamps
    end
  end
end
