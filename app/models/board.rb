class Board
  MIN_ROWS  = 2
  MAX_ROWS  = 48
  MIN_COLS  = 2
  MAX_COLS  = 48

  attr_accessor :rows, :columns, :board_status, :board_values

  def initialize(args)
    if args[:board_values].nil?
      set_default_size(args[:level]&.to_sym, args[:rows], args[:columns])
      set_initial_board_status
      generate_mines(args[:mines], args[:level]&.to_sym)
    else
      self.board_status = args[:board_status]
      self.board_values = args[:board_values]
      self.rows = args[:rows]
      self.columns = args[:columns]
    end
  end

  def visualize
    board_status.chars.each_with_index.map do |status_cell, i|
      Cell.visualize(status_cell, values[i])
    end.join
  end

  def reveal(x, y)
    return board_status if revealed?(x, y)

    reveal_cell(x, y)
    board_status = status.join
  end

  def reveal_all
    self.board_status = Cell::REVEALED_STATE * (rows * columns)
  end

  def flag(x, y)
    return board_status if revealed?(x, y)

    status[(x * columns) + y] = Cell::FLAG_STATE
    board_status = status.join
  end

  def unflag(x, y)
    return board_status if revealed?(x, y)

    status[(x * columns) + y] = Cell::HIDDEN_STATE
    board_status = status.join
  end

  def reveal_cell(x, y)
    return if revealed?(x, y)

    status[(x * columns) + y] = Cell::REVEALED_STATE
    reveal_surroundings(x, y) if is_blank?(x, y)
  end

  ## Cell logics
  def mine?(x, y)
    Cell.mine? values[(x * columns) + y]
  end

  def mines_remaining?
    (0..status.size-1).all? do |i|
      Cell.mine?(values[i]) || Cell.revealed?(status[i])
    end
  end

  private

  ## Cell logics
  def is_blank?(x, y)
    Cell.is_blank? values[(x * columns) + y]
  end

  def revealed?(x, y)
    Cell.revealed? status[(x * columns) + y]
  end

  ## Build

  def set_default_size(level, rows, columns)
    rows ||= 0
    columns ||= 0

    if Game::LEVELS.keys.include? level
      self.rows = Game::LEVELS[level || Game::DEFAULT_LEVEL][:rows]
      self.columns = Game::LEVELS[level || Game::DEFAULT_LEVEL][:columns]
    else
      self.rows = (rows.is_a?(String) ? rows.to_i : rows)
      self.columns = (columns.is_a?(String) ? columns.to_i : columns)
    end
  end

  def set_initial_board_status
    self.board_status = Cell::HIDDEN_STATE * (rows * columns)
  end

  def generate_mines(mines_count, level)
    level ||= Game::DEFAULT_LEVEL

    if Game::LEVELS.keys.include? level
      mines_count ||= Game::LEVELS[level][:mines_count]
    else
      mines_count ||= 0
    end
    mines_count = (mines_count.is_a?(String) ? mines_count.to_i : mines_count)

    tracker = Array.new(rows).map { |_| Array.new(columns, 0) }
    mines = pick_mine_location(mines_count)

    mines.each do |pos|
                posx = pos / columns
                posy = pos - (posx * columns)

                increase_counters(tracker, posx, posy)
              end
    mines.each do |pos|
      posx = pos / columns
      posy = pos - (posx * columns)

      tracker[posx][posy] = Cell::MINE_VALUE
    end

    self.board_values = tracker.map { |row| row.join }.join
  end

  def pick_mine_location(size)
    (0..((rows * columns) - 1)).to_a.sample(size)
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

  # Utilities

  def reveal_surroundings(x, y)
    surroundings = []

    if x > 0
      surroundings.push([x-1, y-1]) if y > 0
      surroundings.push([x-1, y])
      surroundings.push([x-1, y+1]) if y < (columns - 1)
    end

    if x < (rows - 1)
      surroundings.push([x+1, y-1]) if y > 0
      surroundings.push([x+1, y])
      surroundings.push([x+1, y+1]) if y < (columns - 1)
    end
      
    surroundings.push([x, y-1]) if y > 0
    surroundings.push([x, y+1]) if y < (columns - 1)

    surroundings.each { |pair| reveal_cell(pair[0], pair[1]) }
  end

  def values
    @values ||= board_values.chars
  end

  def status
    @status ||= board_status.chars
  end
end