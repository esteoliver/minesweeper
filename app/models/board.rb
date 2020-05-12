class Board
  MIN_ROWS  = 8
  MAX_ROWS  = 48
  MIN_COLS  = 8
  MAX_COLS  = 48
  MIN_MINES = 10

  attr_accessor :rows, :columns, :board_status, :board_values

  def initialize(**args)
    set_default_size **args.slice(:rows, :columns, :level)
    set_initial_board_status
    generate_mines(**args.slice(:mines_count, :level))
  end

  def self.visualize(status, values)
    status.each_with_index.map { |status_cell, i| Cell.visualize(status_cell, values[i]) }
  end

  private

  def set_default_size(rows: 0, columns: 0, level: Game::DEFAULT_LEVEL)
    self.rows ||= Game::LEVELS[level][:rows]
    self.columns ||= Game::LEVELS[level][:columns]
  end

  def set_initial_board_status
    self.board_status = Cell::HIDDEN_STATE * (rows * columns)
  end

  def generate_mines(mines_count: nil, level: Game::DEFAULT_LEVEL)
    tracker = Array.new(rows).map { |_| Array.new(columns, 0) }
    mines = pick_mine_location.take(mines_count || Game::LEVELS[level][:mines_count])

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