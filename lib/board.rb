class Board
  attr_reader :board, :size

  DISPLAY_VALUES = {
    x: "X",
    o: "O",
    nil => "-"
  }

  def initialize(size: 3)
    @board = create_grid(size)
    @size = size
  end

  def [](*position)
    row, column = position
    self.board[row][column]
  end

  def []=(*position, value)
    row, column = position
    self.board[row][column] = value
  end

  def display_board
    column_display = "Col  "
    (1..size).each { |col| column_display.concat(" #{col}")}
    puts column_display
    board.each_with_index do |row, idx|
      print "Row #{idx + 1} "
      row.each { |square| print "#{DISPLAY_VALUES[square]} " }
      puts ""
    end
  end

  def move(symbol, *position)
    row, column = position
    unless self[row, column].nil?
      raise IllegalMoveError.new("\nThat position is taken.\n")
    end
    self[row, column] = symbol
  end

  def winning_move?(*position)
    row_idx, col_idx = position
    winning_row?(row_idx) || winning_column?(col_idx) || winning_diagonal?(row_idx, col_idx)
  end

  def duplicate
    dup = Board.new(size: size)
    (0...board.size).each do |row|
      (0...board.size).each do |column|
        dup[row, column] = self[row, column]
      end
    end

    dup
  end

  private

  def winning_row?(row_idx)
    # The board is arranged into rows by default, so can be accessed with the index
    winning_combination?(board[row_idx].uniq)
  end

  def winning_column?(col_idx)
    # Columns need to be derived from coordinates
    column_content = (0...size).inject([]) do |accum, row_idx|
      accum << self[row_idx, col_idx]
    end

    winning_combination?(column_content.uniq)
  end

  def winning_diagonal?(row_idx, col_idx)
    # If row and column index are the same, check the diagonal
    # where they are the same for all squares
    if row_idx == col_idx
      content = []
      (0...size).each { |idx| content << self[idx, idx] }
      return true if winning_combination?(content.uniq)
    end

    # If the coordinates of the square to check add up to 1 less than the length
    # of the board (because arrays start at 0), check all squares where that is the case
    combined_size = size - 1
    if row_idx + col_idx == combined_size
      content = []
      row = 0
      col = combined_size
      size.times do
        content << self[row, col]
        row += 1
        col -= 1
      end
      return true if winning_combination?(content.uniq)
    end

    false
  end

  def winning_combination?(content)
    # If the entire row/column/diagonal has only one value, and is not nil, then that player wins
    content.length == 1 && !content.first.nil?
  end

  def create_grid(size)
    grid = []
    size.times do
      row = []
      size.times do
        row << nil
      end
      grid << row
    end

    grid
  end
end
