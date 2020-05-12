class AnonymousGame
  class << self
    def get(player_id)
      JSON.parse(redis.get("#{namespace}:#{player_id}"))
    end
    
    def set(player_id, game)
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