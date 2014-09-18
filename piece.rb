# coding: utf-8

class Piece

  attr_reader :color, :position, :king, :board

  def initialize(position, color, board)
    @position = position
    @color = color
    @king = false
    @board = board

    board[position] = self
  end

  def perform_slide
  end

  def perform_jump
  end

  def symbol
    color == :black ? "●" : "○"
  end

  protected

  def move_diffs
    king ? [1, -1] : [1]
  end



end