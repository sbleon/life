require_relative 'cell'

class Board
  attr_reader :seed

  def initialize(seed = nil)
    # Max seed is 2^25. Bits map to 5 x 5 grid around origin.
    # Most significant bits start at upper-left.
    @seed = seed || Random.rand(33554432)
    bits = @seed.to_s(2).rjust(25, '0') # binary format, padded to 25 characters
    (-2..2).map(&:to_i).reverse.each do |y|
      (-2..2).each do |x|
        state = bits.slice!(0) == '1' ? true : false
        set(x, y, state)
      end
    end
  end

  def cells
    @cells ||= {}
  end

  def count_living(cell_set)
    cell_set.count(&:alive?)
  end

  def get_cell(x, y)
    cells[key(x,y)] ||= Cell.new(false)
  end

  def get_state(x, y)
    if cells[key(x,y)]
      cells[key(x,y)].state
    else
      false
    end
  end

  def living_cell_coordinates
    live_cells = cells.select do |cell_key, cell|
      cell.alive?
    end
    live_cells.map do |cell_key, cell|
      cell_key.split(',').map(&:to_i)
    end
  end

  def neighbors_for(cell_key)
    x, y = cell_key.split(',').map(&:to_i)
    {
      key(x + 1, y - 1) => get_cell(x + 1, y - 1),
      key(x + 1, y    ) => get_cell(x + 1, y    ),
      key(x + 1, y + 1) => get_cell(x + 1, y + 1),
      key(x    , y - 1) => get_cell(x    , y - 1),
      key(x    , y + 1) => get_cell(x    , y + 1),
      key(x - 1, y - 1) => get_cell(x - 1, y - 1),
      key(x - 1, y    ) => get_cell(x - 1, y    ),
      key(x - 1, y + 1) => get_cell(x - 1, y + 1)
    }
  end

  def set(x, y, state)
    cells[key(x,y)] ||= Cell.new(state)
    cells[key(x,y)].state = state
  end

  def tick
    updated_cells = {}
    cell_keys = cells.keys
    cell_keys.each do |focus_key|
      focus_x, focus_y = focus_key.split(',')
      cell = get_cell(focus_x, focus_y)
      neighbors = neighbors_for(focus_key)
      num_living_neighbors = count_living(neighbors.values)
      updated_cells[focus_key] = Cell.new(cell.fate(num_living_neighbors))
      neighbors.each do |neighbor_key, neighbor|
        num_living_neighbors = count_living(neighbors_for(neighbor_key).values)
        updated_cells[neighbor_key] ||= Cell.new(neighbor.fate(num_living_neighbors))
      end
    end
    @cells = updated_cells.reject do |cell_key, cell|
      cell.dead?
    end
  end

  private

  def key(x,y)
    "#{x},#{y}"
  end
end