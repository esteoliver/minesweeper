class Api::V1::GamesController < ApiController
  def create
    if player_signed_in?
    else
      puts @anonymous_player
      render_jsonapi Game.create_anonymous(@anonymous_player)
    end
  end
end
