require 'debugger'
require_relative 'piece'

class Board

  attr_reader :grid

  def initialize(setup = true)
    @grid = Array.new(8) { Array.new(8) }
    populate_grid if setup
  end

  def move(*move_sequence)
    piece = self[move_sequence.shift]
    #is there a piece at position?
    raise "There is no piece at this start position" if piece.nil?
    #determine if slide or jump, check_move_legality
    piece.perform_moves!(*move_sequence)
  end

  def [](position)
    i, j = position
    @grid[i][j] unless @grid[i] == nil
  end

  def []=(position, piece)
    i, j = position
    @grid[i][j] = piece unless @grid[i] == nil
  end

  private

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
    to_s
  end

  def fill_row(color)
    fill_rows = (color == :black) ? [0, 1, 2] : [5, 6, 7]

    fill_rows.each do |row|
      if row % 2 == 0
        1.step(7, 2).each { |column| Piece.new([row, column], color, self) }
      else
        0.step(6, 2).each { |column| Piece.new([row, column], color, self) }
      end
    end
  end

  def populate_grid
    [:red, :black].each do |color|
      fill_row(color)
    end
  end

end