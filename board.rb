require 'debugger'
require_relative 'piece'

class Board

  attr_reader :grid

  def initialize(setup = true)
    create_grid(setup)
  end

  def [](position)
    i, j = position
    @grid[i][j] unless @grid[i] == nil
  end

  def []=(position, piece)
    i, j = position
    @grid[i][j] = piece unless @grid[i] == nil
  end

  protected

  def to_s
    rows_string = "   " + ('a'..'h').to_a.join("  ") + "\n"

    @grid.each_with_index do |row, row_num|
      rows_string += "#{row_num + 1}  " + row.map do |piece|
        piece.nil? ? "-" : piece.symbol
      end.join("  ") + "\n"
    end
    rows_string
  end

  def inspect
    nil
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