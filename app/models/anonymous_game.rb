class AnonymousGame
  class << self
    def get(player_id)
      attrs = JSON.parse(redis.get("#{namespace}:#{player_id}"))
      Game.new(attrs.merge(level: 'custom').with_indifferent_access)
    end
    
    def set(player_id, game)
      puts "New game for Player #{player_id}"
  
      redis.set "#{namespace}:#{player_id}", game.to_json, ex: 600
      game
    end

    def exists(player_id)
      redis.exists("#{namespace}:#{player_id}")
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