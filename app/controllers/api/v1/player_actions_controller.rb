class Api::V1::PlayerActionsController < ApiController

  before_action :set_game

  def reveal
    return render json: :unauthorized if anonymous? && !current?

    game = perform_action('reveal')
    if player_signed_in?
      render_jsonapi game
    else
      render json: Api::V1::GameSerializer.new(game).to_json
    end
  end

  def flag
    return render json: :unauthorized if anonymous? && !current?

    game = perform_action('flag')
    if player_signed_in?
      render_jsonapi game
    else
      render json: Api::V1::GameSerializer.new(game).to_json
    end
  end

  def unflag
    return render json: :unauthorized if anonymous? && !current?

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
      @anonymous_player
    )    
  end

  def set_game
    @game ||= find_game
  end

  def find_game
    if current? && anonymous?
      Game.find_anonymous(@anonymous_player)
    elsif current? && player_signed_in?
      current_player.current_game
    elsif player_signed_in?
      current_player.games.find(params[:id])
    end
  end

  def anonymous?
    !player_signed_in?
  end

  def current?
    params[:id] == 'current'
  end

  def action_params
    params.require(:player_action).permit(:x, :y)
  end
end
