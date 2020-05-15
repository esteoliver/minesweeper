class Action
  def self.perform(game, x, y, action, player = nil)
    return game if game.over?

    if action == 'reveal'
      game.reveal(x.to_i, y.to_i)
    elsif action == 'flag'
      game.flag(x.to_i, y.to_i)
    elsif action == 'unflag'
      game.unflag(x.to_i, y.to_i)
    end

    game.id.nil? ? AnonymousGame.set(player, game) : game.save!
    game
  end
end