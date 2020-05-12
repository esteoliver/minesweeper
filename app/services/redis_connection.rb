class RedisConnection
  def initialize(config = {})
    @@connection ||= Redis::Namespace.new("minesweeper", :redis => Redis.new(config))
  end

  def self.connection
    @@connection
  end
end