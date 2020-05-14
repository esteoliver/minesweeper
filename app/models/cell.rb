class Cell
  HIDDEN_STATE   = 'H' # hidden
  FLAG_STATE     = 'F' # flag
  REVEALED_STATE = 'R' # revealed

  MINE_VALUE  = 'M'
  BLANK_VALUE = '0'

  def self.visualize(state, value)
    return FLAG_STATE if state == FLAG_STATE
    return HIDDEN_STATE if state == HIDDEN_STATE
    return value if state == REVEALED_STATE
  end


  def self.is_blank?(value)
    value == BLANK_VALUE
  end

  def self.revealed?(state)
    state == REVEALED_STATE
  end

  def self.flag?(state)
    state == FLAG_STATE
  end

  def self.mine?(value)
    value == MINE_VALUE
  end
end