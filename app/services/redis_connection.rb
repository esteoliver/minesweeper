class RedisConnection
  @@connection = nil

  def initialize(config = {})
    @@connection ||= Redis::Namespace.new("minesweeper", :redis => Redis.new(config))
  end

  def self.connection
    RedisConnection.new if @@connection.nil?
    @@connection
  end
end