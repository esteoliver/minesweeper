# Representation of a gameboard of minesweeper
#
# Levels configuration:
#   Beginner (8x8, 10 mines) 
#   Intermediate (16x16, 40 mines)
#   Expert (24x24, 99 mines)  
class Game < ApplicationRecord

  DEFAULT_LEVEL = :intermediate
  LEVELS = {
    beginner: { rows: 8, columns: 8, mines_count: 10 },
    intermediate: { rows: 16, columns: 16, mines_count: 40 },
    expert: { rows: 24, columns: 24, mines_count: 99 }
  }.freeze

  validates :rows, presence: true,
                   numericality: { 
                      greater_than_or_equal_to: Board::MIN_ROWS,
                      less_than_or_equal_to: Board::MAX_ROWS
                    }
  validates :columns, presence: true,
                      numericality: { 
                        greater_than_or_equal_to: Board::MIN_COLS,
                        less_than_or_equal_to: Board::MAX_COLS
                      }

  # build a new game without params
  def initialize(args)
    args = {} if args.nil?

    super(args.except(*invalid_args_to_initialize))
    self.assign_attributes Board.new(**args).as_json
  end

  private 

  def invalid_args_to_initialize
    %i(level board board_count mines mines_count)
  end
end
