class Board
  DEFAULT_LEVEL = :intermediate
  LEVELS = {
    beginner: { rows: 8, columns: 8, mines_count: 10 },
    intermediate: { rows: 16, columns: 16, mines_count: 40 },
    expert: { rows: 24, columns: 24, mines_count: 99 }
  }.freeze
  MIN_ROWS  = 2
  MAX_ROWS  = 48
  MIN_COLS  = 2
  MAX_COLS  = 48

  attr_accessor :rows, :columns, :board_status, :board_values, :mines

  def initialize(attributes = {})
    if attributes[:level] == 'custom'
      self.rows    = attributes[:rows].to_i
      self.columns = attributes[:columns].to_i
      self.mines   = attributes[:mines].to_i
    elsif LEVELS.keys.map(&:to_s).include? attributes[:level]
      set_level attributes[:level].to_sym
    else
      set_default
    end

    if attributes[:board_status].nil?
      set_initial_board_status
    else
      self.board_status = attributes[:board_status]
    end

    if attributes[:board_values].nil?
      generate_mines
    else
      self.board_values = attributes[:board_values]
    end
  end

  def attributes
    {
      rows: rows, 
      columns: columns,
      board_status: board_status,
      board_values: board_values
    }
  end

  def visualize
    status.each_with_index.map do |status_cell, i|
      Cell.visualize(status_cell, values[i])
    end.join
  end

  ##### ACTIONS

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

  ###### CELLS
  def mine?(x, y)
    Cell.mine? values[(x * columns) + y]
  end

  def mines_remaining?
    (0..status.size-1).all? do |i|
      Cell.mine?(values[i]) || Cell.revealed?(status[i])
    end
  end

  def is_blank?(x, y)
    Cell.is_blank? values[(x * columns) + y]
  end

  def revealed?(x, y)
    Cell.revealed? status[(x * columns) + y]
  end

  private

  ###### DEFAULT AND INITIAL VALUES

  def set_default
    self.rows    = LEVELS[DEFAULT_LEVEL][:rows]
    self.columns = LEVELS[DEFAULT_LEVEL][:columns]
    self.mines   = LEVELS[DEFAULT_LEVEL][:mines_count]
  end

  def set_level(level)
    self.rows    = LEVELS[level][:rows]
    self.columns = LEVELS[level][:columns]
    self.mines   = LEVELS[level][:mines_count]
  end

  def set_initial_board_status
    self.board_status = Cell::HIDDEN_STATE * (rows * columns)
  end

  def generate_mines
    if mines <= 0 || mines >= (columns * rows)
      self.board_values = nil
      return
    end

    tracker = Array.new(rows).map { |_| Array.new(columns, 0) }
    set_values(tracker)
    set_mines(tracker)
    self.board_values = tracker.map { |row| row.join }.join
  end

  def mines_location
    @mine_location ||= (0..((rows * columns) - 1)).to_a.sample(mines)
  end

  def set_values(tracker)
    mines_location.each do |pos|
      posx = pos / columns
      posy = pos - (posx * columns)
      set_surrounding(tracker, posx, posy)
    end
  end

  def set_mines(tracker)
    mines_location.each do |pos|
      posx = pos / columns
      posy = pos - (posx * columns)
      tracker[posx][posy] = Cell::MINE_VALUE
    end
  end

  def set_surrounding(tracker, x, y)
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

  ###### Utilities

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