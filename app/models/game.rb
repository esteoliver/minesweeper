# Representation of a gameboard of minesweeper
#
# Levels configuration:
#   Beginner (8x8, 10 mines) 
#   Intermediate (16x16, 40 mines)
#   Expert (24x24, 99 mines)  
class Game < ApplicationRecord
  belongs_to :player, optional: true

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
  validates :board_values, presence: { message: "invalid number of mines set" }

  class << self
    def create_anonymous(attrs)
      player = attrs.delete('player')
      game = Game.new(attrs)
      game.validate!
      AnonymousGame.set(player, game)
    end

    def find_anonymous(anonymous_player, **args)
      raise_no_current_game! unless AnonymousGame.exists(anonymous_player)
      
      AnonymousGame.get(anonymous_player)
    end

    def initialize_filtered_attrs(attrs)
      (attrs.to_h || {}).reject do |k,v| 
        invalid_key = %w(level mines).include?(k)
        if (!invalid_key && k == 'player')
          if v.is_a?(Player) || Player.exists?(v)
            invalid_key = false
          else
            invalid_key = true
          end
        end
        invalid_key
      end
    end  
  end

  # build a new game without params
  def initialize(attrs = {})
    board_attrs = Board.new(attrs || {}).attributes
    super(Game.initialize_filtered_attrs(attrs).merge(board_attrs))
  end

  def touch
    update!(updated_at: DateTime.now)
    self
  end

  def visualize
    board.visualize
  end

  def reveal(x,y)
    self.board_status = board.reveal(x, y)

    if board.mine?(x,y)
      # GAME OVER - you lost
      self.over   = true
      self.winner = false
      self.board_status = board.reveal_all
    elsif board.mines_remaining?
      # GAME OVER - you win!
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

  def board
    Board.new self.attributes.merge(level: 'custom').with_indifferent_access
  end

  def self.raise_no_current_game!
    raise ActiveRecord::RecordNotFound.new("No current game available", "game", "id", "current")
  end
end
