class ComputerPlayer < Player
  def initialize
    @name = "Computer Player"
  end

  def get_move(board)
    valid_move = false
    until valid_move
      row, col = generate_coordinates(board.size)
      valid_move = true if board[row, col].nil?
    end

    [row, col]
  end

  private

  def generate_coordinates(limit)
    generator = Random.new
    row = generator.rand(0...limit)
    col = generator.rand(0...limit)
    [row, col]
  end
end
