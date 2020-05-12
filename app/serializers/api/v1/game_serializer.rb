class Api::V1::GameSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :player_id, :rows, :columns, :over, :winner, :time

  attribute :display do |object|
    object.visualize
  end
end
