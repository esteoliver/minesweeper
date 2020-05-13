class Api::V1::GamesController < ApiController
  def create
    if player_signed_in?
    else
      if params[:new].blank?
        render_jsonapi Game.create_or_find_anonymous(@anonymous_player)
      else
        render_jsonapi Game.create_anonymous(@anonymous_player)
      end
    end
  end
end
