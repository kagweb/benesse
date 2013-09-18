class RenameTypeToResponse < ActiveRecord::Migration
  def up
    rename_column 'confirmations', 'type', 'response'
  end

  def down
    rename_column 'confirmations', 'response', 'type'
  end
end
