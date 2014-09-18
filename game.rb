#!/usr/bin/env ruby

require_relative 'board'
require_relative 'player'
require_relative 'piece'
require_relative 'helper_methods'

class Game

  include HelperMethods

  attr_reader :player1, :player2, :turn, :board, :winner

  def initialize
    @board = Board.new(true)
    @player1 = Player.new(:black)
    @player2 = Player.new(:red)
    @turn = :black
  end

  def run
    until won?
      puts board
      puts "It's #{turn}'s turn"
      take_turn
      @turn = other_color(@turn)
    end

    puts "I won?"
  end

  def take_turn
    current_player = (turn == :black) ? player1 : player2

    begin
      move_seq = current_player.get_move_sequence

      raise "It's #{turn}'s turn" if board[move_seq.first].color != turn
      board.move(*move_seq)
    rescue StandardError => e
      puts "#{e.message}"
      retry
    end

  end

  def won?
    return false unless all_pieces_of(turn).empty?
    @winner = other_color(turn)
  end

  def all_pieces_of(color)
    board.grid.flatten.compact.select { |piece| piece.color == color }
  end

end

if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.run
end
