class Api::V1::PlayerActionsController < ApiController

  before_action :set_game

  def reveal
    game = perform_action('reveal')
    if player_signed_in?
      render_jsonapi game
    else
      render json: Api::V1::GameSerializer.new(game).to_json
    end
  end

  def flag
    game = perform_action('flag')
    if player_signed_in?
      render_jsonapi game
    else
      render json: Api::V1::GameSerializer.new(game).to_json
    end
  end

  def unflag
    game = perform_action('unflag')
    if player_signed_in?
      render_jsonapi game
    else
      render json: Api::V1::GameSerializer.new(game).to_json
    end
  end

  private 

  def perform_action(action)
    Action.perform(
      @game, 
      action_params[:x], 
      action_params[:y], 
      action,
      @anonymous_player,
    )    
  end

  def set_game
    @game = find_game
  end

  def find_game
    if current_game?
      player_signed_in? ? current_player.current_game : Game.find_anonymous(@anonymous_player)
    end
  end

  def current_game?
    params[:id] == 'current'
  end

  def action_params
    params.require(:player_action).permit(:x, :y)
  end
end
