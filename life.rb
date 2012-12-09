require 'gosu'
require_relative 'lib/board'
require_relative 'lib/cell'

class LifeWindow < Gosu::Window
  #####################
  # Startup functions #
  #####################

  def initialize(width, height, fullscreen, update_interval)
    @width = width
    @height = height
    setup
    super(width, height, fullscreen, update_interval)
    self.caption = 'Game of Life!'
  end

  def restart
    setup
  end

  def setup
    @board = Board.new()
  end

  ##################
  # Input handlers #
  ##################

  def button_down(id)
    if id == Gosu::KbEscape then
      close
    end
    if id == Gosu::KbSpace then
      restart
    end
  end

  #####################
  # Drawing functions #
  #####################
  def draw
    draw_rectangle(0, 0, @width, @height, Gosu::Color::WHITE)
    font = Gosu::Font.new(self, 'Times New Roman', 12)
    font.draw("Seed is #{@board.seed}", 0, 0, 1, 1, 1, Gosu::Color::BLACK)
    @board.living_cell_coordinates.each do |coords|
      draw_cell(coords[0], coords[1])
    end
  end

  def draw_cell(board_x, board_y)
    x = board_x * 10 + @width / 2
    y = @height / 2 + board_y * 10
    draw_rectangle(x - 3, y - 3, x + 3, y + 3, Gosu::Color::BLACK)
  end

  def draw_rectangle(x1, y1, x2, y2, color)
    draw_quad(x1, y1, color, x2, y1, color, x2, y2, color, x1, y2, color)
  end

  #######################
  # Game loop functions #
  #######################
  def update
    @board.tick
  end
end

window = LifeWindow.new(640, 480, false, 400)
window.show