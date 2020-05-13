class Api::V1::GamesController < ApiController
  def index
    render_jsonapi Game.none unless player_signed_in?
  end

  def show
    if current?
      render_jsonapi Game.find_anonymous(@anonymous_player) unless player_signed_in?
    end
  end

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

  private

  def current?
    params[:id] == 'current'
  end
end
