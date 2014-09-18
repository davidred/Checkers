require 'debugger'
require_relative 'piece'

class Board

  SLIDES = [[ 1, -1 ], [ 1, 1 ], [ -1, -1 ], [ -1, 1 ]]
  JUMPS  = [[ 2, -2 ], [ 2, 2 ], [ -2, -2 ], [ -2, 2 ]]

  attr_reader :grid

  def initialize(setup = true)
    create_grid(setup)
  end

  def move(start_pos, end_pos)
    piece = self[start_pos]
    #is there a piece at position?
    raise "There is no piece at this start position" if piece.nil?
    #determine if slide or jump, check_move_legality
    move_type = slide_or_jump?(start_pos, end_pos)

    if (move_type == :slide) ? piece.slide(end_pos) : piece.jump(end_pos)
        make_move(start_pos, end_pos, move_type) #make the move
    else
      raise "Your piece can't move like that"
    end
  end

  def [](position)
    i, j = position
    @grid[i][j] unless @grid[i] == nil
  end

  def []=(position, piece)
    i, j = position
    @grid[i][j] = piece unless @grid[i] == nil
  end

  def middle(start_pos, end_pos)
    x, y = start_pos
    i, j = end_pos

    [(x + i)/2, (y + j)/2]
  end

  protected

  def to_s
    rows_string = "   " + ('0'..'7').to_a.join("  ") + "\n"

    @grid.each_with_index do |row, row_num|
      rows_string += "#{row_num}  " + row.map do |piece|
        piece.nil? ? "-" : piece.symbol
      end.join("  ") + "\n"
    end
    rows_string
  end

  def inspect
    nil
  end

  def slide_or_jump?(start_pos, end_pos)
    x, y = start_pos
    i, j = end_pos
    step = [i - x, j - y]

    return :slide if SLIDES.include?(step)
    return :jump if JUMPS.include?(step)
    raise "This is neither a slide nor a jump."

  end

  def make_move(start_pos, end_pos, move_type)
    piece = self[start_pos]

    self[start_pos] = nil
    self[end_pos] = piece
    self[middle(start_pos, end_pos)] = nil if move_type == :jump

    piece.position = end_pos

  end

  def fill_row(color)
    #debugger
    fill_rows = (color == :black) ? [0, 1, 2] : [5, 6, 7]

    fill_rows.each do |row|
      if row % 2 == 0
        1.step(7,2).each { |column| Piece.new( [row, column], color, self ) }
      else
        0.step(6,2).each { |column| Piece.new( [row, column], color, self ) }
      end
    end
  end

  def create_grid(setup)
    @grid = Array.new(8) { Array.new(8) }
    return unless setup

    [:red, :black].each do |color|
      fill_row(color)
    end
  end

end