class Api::V1::PlayerActionsController < ApiController

  def create
    if player_signed_in?
    else
      game = Action.perform(@anonymous_player, 
                              player_action_params[:x],
                              player_action_params[:y],
                              player_action_params[:action],
                              player_action_params[:game_id]
                            )
      
      render json: Api::V1::GameSerializer.new(game).to_json
    end
  end

  private 

  def player_action_params
    params.require(:player_action).permit(:x, :y, :action, :game_id)
  end
end
