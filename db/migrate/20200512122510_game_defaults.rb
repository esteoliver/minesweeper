class GameDefaults < ActiveRecord::Migration[6.0]
  def change
    change_column_default :games, :time, from: nil, to: 0
    change_column_default :games, :winner, from: nil, to: false
  end
end
