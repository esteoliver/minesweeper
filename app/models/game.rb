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
    intermediate: { rows: 16, columns: 16, mines_count: 1 },
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

    self.assign_attributes Board.new(args).as_json
  end

  def self.create_anonymous(anonymous_player, **args)
    return {} if anonymous_player.nil?

    AnonymousGame.set(anonymous_player, Game.new(args))
  end

  def self.create_or_find_anonymous(anonymous_player, **args)
    return AnonymousGame.get(anonymous_player) if AnonymousGame.exists(anonymous_player)

    create_anonymous(anonymous_player, args)
  end

  def visualize
    board.visualize
  end

  def reveal(x,y)
    self.board_status = board.reveal(x, y)

    # GAME OVER - you lost
    if board.mine?(x,y)
      self.over   = true
      self.winner = false
    elsif board.mines_remaining?
      self.over   = true
      self.winner = true
    end
  end

  def flag(x,y)
    self.board_status = board.flag(x, y)
  end

  def unflag(x,y)
    self.board_status = board.unflag(x, y)
  end
  
  private 

  def invalid_args_to_initialize
    %i(level mines_count anonymous_player)
  end  

  def board
    Board.new self.attributes.with_indifferent_access
  end
end
