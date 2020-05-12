class Api::V1::GamesController < ApiController
  def create
    if player_signed_in?
    else
      render_jsonapi Game.create_anonymous(@anonymous_player)
    end
  end
end
