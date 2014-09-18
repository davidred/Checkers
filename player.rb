class Player

  columns = ('a'..'h').to_a.zip((0..7).to_a).to_h
  rows = ('1'..'8').to_a.zip((0..7).to_a).to_h
  S_TO_I = columns.merge(rows) #input string to board index

  def initialize(color)
    @color = color
  end

  def get_move_sequence
    p "Enter a move sequence (a1, b2)"
    sequence = gets.chomp
    #check for valid expression
    unless sequence =~ /\A([a-h][1-8] )+[a-h][1-8]\Z/
      puts "Invalid entry, enter a sequence in the form of (a1, b2)"
      sequence = gets.chomp
    end
    "a1 b2 c3"
    array_of_strings = sequence.split
    array_of_moves = array_of_strings.map do |string|
      [S_TO_I[string[1]], S_TO_I[string[0]]]
    end
  end

end