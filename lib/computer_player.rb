class ComputerPlayer < Player
  attr_reader :smart, :symbol

  def initialize(smart, symbol)
    @name = "Computer Player"
    @smart = smart
    @symbol = symbol
  end

  def get_move(board, smart)
    valid_move = false
    # If the computer player is set to higher difficulty,
    # make sure to always win if possible, and block the opponent
    # if possible
    winning_move = find_winning_move(board) if smart
    if winning_move
      valid_move = true
      row, col = winning_move
    end

    # Otherwise, randomly generate the move
    until valid_move
      row, col = generate_coordinates(board.size)
      valid_move = true if board[row, col].nil?
    end

    [row, col]
  end

  private

  def find_winning_move(board)
    opponent = symbol == :x ? :o : :x
    # Check every square to see if playing there would win the game,
    # or if the opponent playing there would win the game for them
    our_winning_square = nil
    opponent_winning_square = nil

    (0...board.size).each do |row|
      (0...board.size).each do |col|
        if board[row, col].nil?
          duplicate = board.duplicate
          duplicate[row, col] = symbol
          if duplicate.winning_move?(row, col)
            our_winning_square = [row, col]
          end
          duplicate[row, col] = opponent
          if duplicate.winning_move?(row, col)
            opponent_winning_square = [row, col]
          end
        end
      end
    end

    # If there is a square where we win, return that
    # Otherwise, if there is a square that blocks the opponent from winning, return that
    our_winning_square || opponent_winning_square || nil
  end

  def generate_coordinates(limit)
    generator = Random.new
    row = generator.rand(0...limit)
    col = generator.rand(0...limit)
    [row, col]
  end
end
