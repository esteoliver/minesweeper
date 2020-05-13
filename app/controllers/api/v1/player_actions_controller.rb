class Api::V1::PlayerActionsController < ApiController

  before_action :set_game

  def reveal
    if player_signed_in?
    else
      game = perform_action('reveal')
      render json: Api::V1::GameSerializer.new(game).to_json
    end
  end

  def flag
    if player_signed_in?
    else
      game = perform_action('flag')
      render json: Api::V1::GameSerializer.new(game).to_json
    end
  end

  def unflag
    if player_signed_in?
    else
      game = perform_action('unflag')
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
    if player_signed_in?
      Game.new
    else
      Game.find_anonymous(@anonymous_player)
    end
  end

  def current_game?
    params[:id] == 'current'
  end


  def action_params
    params.require(:player_action).permit(:x, :y)
  end
end
