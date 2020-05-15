class Api::SessionsController < DeviseTokenAuth::SessionsController       
  protect_from_forgery with: :null_session       
  
  private        
  
  def resource_params
    params.require(:player).permit(:nickname, :password)
  end        
  
  def render_create_success         
    render json: { player: resource_data }       
  end     
end