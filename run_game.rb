require_relative 'lib/errors.rb'
require_relative 'lib/player.rb'
require_relative 'lib/human_player.rb'
require_relative 'lib/computer_player.rb'
require_relative 'lib/board.rb'
require_relative 'lib/game.rb'

if $PROGRAM_NAME == __FILE__
  game = Game.new(ai: false, size: 3)
  game.play
end
