class AdjustGame < ActiveRecord::Migration[6.0]
  def change
    remove_column :games, :mines, :datetime
    rename_column :games, :board, :board_status
    rename_column :games, :board_count, :board_values
  end
end
