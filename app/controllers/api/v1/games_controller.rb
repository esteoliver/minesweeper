class Api::V1::GamesController < ApiController
  def index
    render_jsonapi Game.none unless player_signed_in?

    render_jsonapi current_player.games.order(updated_at: :desc), page: params[:page]
  end

  def show
    if current?
      if player_signed_in?
        render_jsonapi current_player.current_game
      else
        render_jsonapi Game.find_anonymous(@anonymous_player)
      end
    else
      if player_signed_in?
        render_jsonapi current_player.games.find(params[:id]) 
      else
        render json: :unauthorized
      end
    end
  end

  def create
    game = Game.new(game_params)
    game.validate!

    if player_signed_in?
      render_jsonapi Game.create(player: current_player)
    else
      render_jsonapi Game.create_anonymous(@anonymous_player)
    end
  end

  private

  def game_params
    params.require(:game).permit(:level, :rows, :columns, :mines)
  end

  def current?
    params[:id] == 'current'
  end
end
