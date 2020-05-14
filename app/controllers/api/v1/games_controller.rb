class Api::V1::GamesController < ApiController
  before_action :get_game, only: :show

  def index
    return render_jsonapi Game.none unless player_signed_in?

    render_jsonapi current_player.games.order(updated_at: :desc), page: params[:page]
  end

  def show
    return render json: :unauthorized if anonymous? && !current?

    render_jsonapi get_game
  end

  def create
    render_jsonapi (anonymous? ? Game.create_anonymous(game_params) : Game.create!(game_params))
  end

  private

  def game_params
    params.require(:game)
          .permit(:level, :rows, :columns, :mines)
          .merge(player: player)
  end

  def player
    @player ||= current_player || @anonymous_player
  end

  def get_game
    if current? && anonymous?
      Game.find_anonymous(@anonymous_player)
    elsif current? && player_signed_in?
      current_player.current_game
    elsif player_signed_in?
      current_player.games.find(params[:id]).touch
    end
  end

  def anonymous?
    !player_signed_in?
  end

  def current?
    params[:id] == 'current'
  end
end
