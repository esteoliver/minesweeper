class Api::V1::GameSerializer
  include FastJsonapi::ObjectSerializer

  attributes :player_id, :rows, :columns, :over, :winner, :time, :created_at

  set_id { |object| object.id || 'current' }

  attribute :id do |object| 
    object.id || 'current'
  end

  attribute :display do |object|
    object.visualize
  end

  # attribute :last_time_played do |object|
  #   object.updated_at
  # end

  attribute :mines do |object|
    object.board.total_mines
  end

  attribute :flags do |object|
    object.board.total_flags
  end

end
