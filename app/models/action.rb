class Action
  def self.perform(game, x, y, action, player = nil)
    puts "Click (#{x},#{y}) to #{action}"
    puts "Game #{ game.id.nil? ? "search current" : game.id }"

    return game if game.over?

    if action == 'reveal'
      game.reveal(x.to_i, y.to_i)
    elsif action == 'flag'
      game.flag(x.to_i, y.to_i)
    elsif action == 'unflag'
      game.unflag(x.to_i, y.to_i)
    end

    AnonymousGame.set(player, game) if game.id.nil?

    game
  end
end