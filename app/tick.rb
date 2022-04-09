$game = Game.new

def tick args
  $game.args = args
  $game.tick
end
