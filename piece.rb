# coding: utf-8

class Piece
  
  attr_reader :color, :position, :king, :board
  
  def initialize(color, position, board)
    @color = color
    @position = position
    @king = false
    @board = board
    
    board[position] = self  
  end
  
  def perform_slide
  end
  
  def perform_jump
  end
  
  protected
  
  def move_diffs
    king ? [1, -1] : [1]
  end
  
  def symbol
    color == :black ? 


  end
  
end