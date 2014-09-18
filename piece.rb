# coding: utf-8

class Piece

  attr_reader :color, :board, :king

  SLIDES = [[ 1, -1 ], [ 1, 1 ], [ -1, -1 ], [ -1, 1 ]]
  JUMPS  = [[ 2, -2 ], [ 2, 2 ], [ -2, -2 ], [ -2, 2 ]]

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

  def slide(start_pos, end_pos) #check legality, return boolean
    #return all possible sliding steps (color dependant)
    steps = legal_steps.select { |step| step.include?(1) || step.include?(-1) }
    end_positions = steps.map { |step| try_step(start_pos, step) }
    #slide is legal if there is no piece of either color to the diagonal
    legal_end_positions = end_positions.select { |end_pos| board[end_pos].nil? }
    #check if end_pos is one of the legal steps
    legal_end_positions.include?(end_pos)
  end

  def jump(start_pos, end_pos) #check legality, return boolean
    #return all possible jumping steps (color dependant)
    steps = legal_steps.select { |step| step.include?(2) || step.include?(-2) }

    end_positions = steps.map { |step| try_step(start_pos, step) }
    #legal jump if no piece at the end_pos and different color piece in middle
    ##REFACTOR TO METHOD LEGAL_JUMP
    legal_end_positions = end_positions.select do |end_pos|
      piece_at_end_pos = board[end_pos]
      piece_in_middle = board[middle(start_pos, end_pos)]

      piece_at_end_pos.nil? && !piece_in_middle.nil? &&
      piece_in_middle.color != self.color
    end
    #check if end_pos is one of the legal steps
    legal_end_positions.include?(end_pos)
  end

  def symbol
    return color == :black ? "♚" : "♔" if king
    color == :black ? "●" : "○"
  end

  def perform_moves!(*move_sequence)
    start = position
    move_sequence.each do |end_pos|
      move_type = slide_or_jump?(start, end_pos)
      puts "trying to #{move_type} from #{start} to #{end_pos}"
      if move_type == :slide && move_sequence.length > 1
        raise "You can only slide one time"
      elsif (move_type == :slide) ? slide(start, end_pos) : jump(start, end_pos)
        next start = end_pos
      else
        raise "#{end_pos} makes this an invalid sequence of moves"
      end
    end
    make_moves(*move_sequence)
  end

  private

  attr_accessor :king, :position

  def make_moves(*move_sequence)
    move_sequence.each do |end_pos|
      move_type = slide_or_jump?(position, end_pos)
      make_move(position, end_pos, move_type)
    end

    row = move_sequence.last[0]
    promote if (row == 7 && color == :black) || (row == 0 && color == :red)
  end

  def make_move(start_pos, end_pos, move_type)
    board[start_pos] = nil
    board[end_pos] = self
    board[middle(start_pos, end_pos)] = nil if move_type == :jump

    self.position = end_pos

  end

  def legal_steps
    king ? MOVES_HASH[color] + MOVES_HASH[other_color] : MOVES_HASH[color]
  end

  def try_step(start_pos, step)
    x, y = start_pos
    i, j = step

    [x + i, y + j]
  end

  def middle(start_pos, end_pos)
    x, y = start_pos
    i, j = end_pos

    [(x + i) / 2, (y + j) / 2]
  end

  def slide_or_jump?(start_pos, end_pos)
    x, y = start_pos
    i, j = end_pos
    step = [i - x, j - y]

    return :slide if SLIDES.include?(step)
    return :jump if JUMPS.include?(step)
    raise "This is neither a slide nor a jump."

  end

  def other_color
    color == :black ? :red : :black
  end

  def promote
    self.king = true
  end

end