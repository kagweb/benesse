class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :null => false
      t.string :email, :null => false
      t.string :crypted_password, :null => false
      t.string :salt, :null => false
      t.integer :department_id, :null => false

      t.timestamps
    end
  end
end
