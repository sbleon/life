class Cell
  attr_accessor :state

  def initialize(state)
    @state = state
  end

  def alive?
    @state
  end

  def dead?
    !alive?
  end

  def fate(num_neighbors)
    alive? && [2,3].include?(num_neighbors) || dead? && num_neighbors == 3
  end
end