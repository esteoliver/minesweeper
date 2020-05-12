class Api::V1::GamesController < ApiController
  def create
    render_jsonapi Game.new
  end
end
