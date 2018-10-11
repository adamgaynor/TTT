class Game
  attr_reader :board, :players

  def initialize(computer: true, smarter_computer: true, size: 3)
    @board = Board.new(size: size)
    @players = {
      x: HumanPlayer.new("Player 1"),
      o: computer ? ComputerPlayer.new(smarter_computer, :o) : HumanPlayer.new("Player 2")
    }
    @players[:x].set_board_size(size)
    @players[:o].set_board_size(size)
  end

  def play
    turn_count = 0
    turn = nil
    winner = false

    until winner
      turn = turn == :x ? :o : :x
      turn_count += 1

      begin
        current_player = players[turn]
        if current_player.class == HumanPlayer
          puts "#{current_player.name}'s Turn (#{turn.to_s.upcase})"
          board.display_board
        end

        move = get_move_for(current_player)

        board.move(turn, *move)

        if board.winning_move?(*move)
          winner = true
          congratulate_winner(current_player)
          exit
        end

        if turn_count == board.size ** 2
          puts "It's a draw."
          board.display_board
          exit
        end
      rescue IllegalMoveError => error
        puts error.message
        retry
      end
    end
  end

  private

  def get_move_for(player)
    if player.class == HumanPlayer
      player.get_move
    else
      player.get_move(board, player.smart)
    end
  end

  def congratulate_winner(player)
    if player.class == HumanPlayer
      puts "Congratulations #{player.name}, you win!"
    else
      puts "Too bad, the computer won this time..."
    end
    board.display_board
  end
end
