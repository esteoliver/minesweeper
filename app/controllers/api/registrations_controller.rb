class Api::RegistrationsController < DeviseTokenAuth::RegistrationsController       
  protect_from_forgery with: :null_session       
  
  private        
  
  def sign_up_params
    params.require(:player).permit(:nickname, :password, :email)
  end        
  
  def render_create_success
    render json: { player: resource_data }
  end     
end