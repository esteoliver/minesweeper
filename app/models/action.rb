class Action
  def self.perform(player, x, y, action, game_id = nil)
    puts "Player #{player}"
    puts "Click (#{x},#{y}) to #{action}"
    puts "Game #{ game_id.nil? ? "search current" : game_id }"

    if game_id.nil?
      game = AnonymousGame.get(player)
      game.reveal(x.to_i, y.to_i)
      AnonymousGame.set(player, game)
    end

    game
  end
end