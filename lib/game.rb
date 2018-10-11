class Game
  attr_reader :board, :players

  def initialize(ai: true, size: 3)
    @board = Board.new(size: size)
    @players = {
      x: HumanPlayer.new("Player 1"),
      o: ai ? ComputerPlayer.new : HumanPlayer.new("Player 2")
    }
    @players[:x].set_board_size(size)
    @players[:o].set_board_size(size)
  end

  def play
    turn = nil
    winner = nil

    until winner
      turn = (turn == :x ? :o : :x)
      begin
        current_player = players[turn]
        puts "#{current_player.name}'s Turn (#{turn.to_s.upcase})"
        board.display_board
        move = current_player.get_move

        board.move(turn, *move)
        if board.winning_move?(*move)
          winner = true
          if current_player.class == HumanPlayer
            puts "Congratulations #{current_player.name}, you win!"
          else
            puts "Too bad, the computer won this time..."
          end
          board.display_board
        end
      rescue IllegalMoveError => error
        puts error.message
        retry
      end
    end
  end
end
