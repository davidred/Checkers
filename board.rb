class Board
  
  attr_reader :grid    
  
  def initialize(setup = true)
    @grid = create_grid(setup)
  end
  
  protected 
  
  def to_s
    rows = ""
    @grid.each_with_index do |row, row_num|
      row += "#{row_num}  " + row.map do |square|
        square.nil? ? "-" : square.symbol
      
  end
  
  def [](position)
    @grid[position[0]][position[1]]
  end
  
  def []=(position, piece)
    i, j = position
    @grid[i][j] = piece
  end
  
  def fill_row(color)
    fill_rows = (color == :black) ? [0, 1, 2] : [5, 6, 7]  
  end
  
  def create_grid(setup)
    grid = Array.new(8) { Array.new(8) }
    return grid unless setup
    
    [:red, :black].each do |color|
      fill_row(color)
    end
  end
  
end