class SorceryCore < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username,         null: false
      t.string :email,            default: nil # if you use this field as a username, you might want to make it :null => false.
      t.string :crypted_password, default: nil
      t.string :salt,             default: nil
      t.references :department,   null: false

      t.timestamps
    end
    add_index :users, :department_id
  end

  def self.down
    drop_table :users
  end
end
