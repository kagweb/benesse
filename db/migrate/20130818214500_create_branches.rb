class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.integer :project_id, :null => false
      t.string :code, :null => false

      t.timestamps
    end
  end
end
