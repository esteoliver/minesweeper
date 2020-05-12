# Representation of a gameboard of minesweeper
#
# Levels configuration:
#   Beginner (8x8, 10 mines) 
#   Intermediate (16x16, 40 mines)
#   Expert (24x24, 99 mines)  
class Game < ApplicationRecord

  DEFAULT_GAME_LEVEL = :intermediate
  GAME_LEVELS = {
    beginner: { rows: 8, columns: 8, mines_count: 10 },
    intermediate: { rows: 16, columns: 16, mines_count: 40 },
    expert: { rows: 24, columns: 24, mines_count: 99 }
  }.freeze
  BOARD_MIN_ROWS  = 8
  BOARD_MAX_ROWS  = 48
  BOARD_MIN_COLS  = 8
  BOARD_MAX_COLS  = 48
  BOARD_MIN_MINES = 10

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

    super(args.except(*invalid_args_to_initialize))
    set_default_size **args.slice(:rows, :columns, :level)
    set_initial_board_status
    generate_mines(**args.slice(:mines_count, :level))
  end

  private 

  def invalid_args_to_initialize
    %i(level board board_count mines mines_count)
  end

  def set_default_size(rows: 0, columns: 0, level: DEFAULT_GAME_LEVEL)
    self.rows ||= GAME_LEVELS[level][:rows]
    self.columns ||= GAME_LEVELS[level][:columns]
  end

  def set_initial_board_status
    self.board_status = Cell::HIDDEN_STATE * (rows * columns)
  end

  def generate_mines(mines_count: nil, level: DEFAULT_GAME_LEVEL)
    tracker = Array.new(rows).map { |_| Array.new(columns, 0) }
    mines = pick_mine_location.take(mines_count || GAME_LEVELS[level][:rows])

    mines.each do |pos|
                posx = pos / columns
                posy = pos - (posx * columns)

                increase_counters(tracker, posx, posy)
              end
    mines.each do |pos|
      posx = pos / columns
      posy = pos - (posx * columns)

      tracker[posx][posy] = "M"
    end

    self.board_values = tracker.map { |row| row.join }.join
  end

  def pick_mine_location
    cells = Array (0..((rows * columns) - 1))
    Enumerator.new do |y|
      loop do
        picked = rand(cells.size)
        y << cells[picked]
        cells.delete(picked)
      end
    end
  end

  def increase_counters(tracker, x, y)
    if x > 0
      tracker[x-1][y-1] += 1 if y > 0
      tracker[x-1][y] += 1
      tracker[x-1][y+1] += 1 if y < (columns - 1)
    end

    if x < (rows - 1)
      tracker[x+1][y-1] += 1 if y > 0
      tracker[x+1][y] += 1
      tracker[x+1][y+1] += 1 if y < (columns - 1)
    end
      
    tracker[x][y-1] += 1 if y > 0
    tracker[x][y+1] += 1 if y < (columns - 1)
  end
end
