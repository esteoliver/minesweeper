class Cell
  HIDDEN_STATE   = 'H' # hidden
  FLAG_STATE     = 'F' # flag
  REVEALED_STATE = 'R' # revealed

  def self.visualize(state, value)
    return FLAG_STATE if state == FLAG_STATE
    return HIDDEN_STATE if state == HIDDEN_STATE
    return value if state == REVEALED_STATE
  end
end