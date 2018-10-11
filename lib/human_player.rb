class HumanPlayer < Player
  def initialize(name)
    @name = name
  end

  def get_move
    print "Please enter coordinates to play, e.g. 1,2: "
    begin
      move = gets.chomp
      parse_move(move)
    rescue InvalidInputError => error
      puts error.message
      retry
    end
  end

  private

  def parse_move(move)
    unless validate_move?(move)
      raise InvalidInputError.new("\nYou must enter coordinates for a valid position on the board e.g. 1,2\n")
    end
    # Subtract 1 from each coordinate because Arrays start at 0
    move.split(',').map { |num| num.to_i - 1 }
  end

  def validate_move?(move)
    return false if move.length != 3
    (1..board_size).include?(move[0].to_i) && (1..board_size).include?(move[2].to_i)
  end
end
