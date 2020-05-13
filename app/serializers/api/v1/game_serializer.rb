class Api::V1::GameSerializer
  include FastJsonapi::ObjectSerializer

  attributes :player_id, :rows, :columns, :over, :winner, :time


  set_id { |object| object.id || 'current' }

  attribute :id do |object| 
    object.id || 'current'
  end

  attribute :display do |object|
    object.visualize
  end

  attribute :last_time_played do |object|
    object.updated_at
  end
end
