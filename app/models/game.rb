# Representation of a gameboard of minesweeper
#
# Levels configuration:
#   Beginner (8x8, 10 mines) 
#   Intermediate (16x16, 40 mines)
#   Expert (24x24, 99 mines)  
class Game < ApplicationRecord

  DEFAULT_GAME_LEVEL = :intermediate
  GAME_LEVELS = {
    beginner: { rows: 8, columns: 8 },
    intermediate: { rows: 16, columns: 16 },
    expert: { rows: 24, columns: 24 }
  }.freeze
  BOARD_MIN_ROWS = 8
  BOARD_MAX_ROWS = 48
  BOARD_MIN_COLS = 8
  BOARD_MAX_COLS = 48

  validates :mines, presence: true
  validates :board, presence: true
  validates :board_count, presence: true
  validates :rows, presence: true,
                   numericality: { 
                      greater_than_or_equal_to: BOARD_MIN_ROWS,
                      less_than_or_equal_to: BOARD_MAX_ROWS
                    }
  validates :columns, presence: true,
                      numericality: { 
                        greater_than_or_equal_to: BOARD_MIN_COLS,
                        less_than_or_equal_to: BOARD_MAX_COLS
                      }

  # build a new game without params
  def initialize(args)
    args = {} if args.nil?

    super(args.except(invalid_args_to_initialize))
    set_default_size **args
  end

  private 

  def invalid_args_to_initialize
    %i(level board board_count mines)
  end

  def set_default_size(rows: 0, columns: 0, level: DEFAULT_GAME_LEVEL)
    self.rows ||= GAME_LEVELS[level][:rows]
    self.columns ||= GAME_LEVELS[level][:columns]
  end

  def default_rows
  end
end
