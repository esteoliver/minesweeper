class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.belongs_to :player
      t.integer :rows, null: false     # board number of rows
      t.integer :columns, null: false  # board number of columns
      t.string :mines, array: true     # mines positions like coordinates ROW:COL
                                       # e.g. 10:2 
      t.string :board                  # board representation of the game, with the
                                       # status of each cell: 
                                       # H: hidden
                                       # R: revealed
                                       # F: flag
      t.string :board_count            # board count mines for each cell, similar to board
      t.boolean :over, default: false
      t.boolean :winner
      t.integer :time                  # time spent in the game
      t.timestamps
    end
  end
end
