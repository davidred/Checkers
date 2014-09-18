# coding: utf-8

class Piece

  attr_reader :color, :king, :board
  attr_accessor :position

  MOVES_HASH = { :black => [[  1, -1 ], [  1, 1 ], [  2, -2 ], [  2, 2 ]],
                 :red => [[ -1, -1 ], [ -1, 1 ], [ -2, -2 ], [ -2, 2 ]]
               }

  def initialize(position, color, board)
    @position = position
    @color = color
    @king = false
    @board = board

    board[position] = self
  end

  def slide(end_pos) #check legality, return boolean
    #return all possible sliding steps (color dependant)
    ##puts color
    ##puts "legal_steps: #{legal_steps}"
    steps = legal_steps.select { |step| step.include?(1) || step.include?(-1) }
    end_positions = steps.map { |step| try_step(position, step) }
    #slide is legal if there is no piece of either color to the diagonal
    legal_end_positions = end_positions.select { |end_pos| board[end_pos].nil? }
    ##puts "legal slides: #{end_positions}"
    #check if end_pos is one of the legal steps
    legal_end_positions.include?(end_pos)
  end

  def jump(end_pos) #check legality, return boolean
    ##puts color
    ##puts "possible_steps: #{legal_steps}"
    #return all possible jumping steps (color dependant)
    steps = legal_steps.select { |step| step.include?(2) || step.include?(-2) }
    ##puts "jumps: #{steps}"
    end_positions = steps.map { |step| try_step(position, step) }
    ##puts "possible end_positions: #{end_positions}"
    #legal jump if no piece at the end_pos and different color piece in middle
    legal_end_positions = end_positions.select do |end_pos|
      piece_at_end_pos = board[end_pos]
      piece_in_middle = board[board.middle(position, end_pos)]
      piece_at_end_pos.nil? && !piece_in_middle.nil? &&
      piece_in_middle.color != self.color
    end
    ##puts "legal end postions: #{legal_end_positions}"
    #check if end_pos is one of the legal steps
    legal_end_positions.include?(end_pos)
  end

  def symbol
    color == :black ? "●" : "○"
  end

  protected

  def legal_steps
    king ? MOVES_HASH[color] + MOVES_HASH[other_color] : MOVES_HASH[color]
  end

  def try_step(start_pos, step)
    x, y = start_pos
    i, j = step
    [x + i, y + j]
  end

  def other_color
    color == :black ? :white : :black
  end



end