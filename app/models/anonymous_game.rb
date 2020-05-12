class AnonymousGame
  class << self
    def get(player_id)
      Game.new JSON.parse(redis.get("#{namespace}:#{player_id}"))
    end
    
    def set(player_id, game)
      puts "New game for Player #{player_id}"
  
      redis.set "#{namespace}:#{player_id}", game.to_json
      game
    end

    def create(args)
      AnonymousGame.set(args[:anonymous_player], Game.new(args))
    end
  
    private
    
    def redis
      RedisConnection.connection
    end

    def namespace
      "anongame"
    end
  end
end