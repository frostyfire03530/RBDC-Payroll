class RegistrationsController < Devise::RegistrationsController
    
  def new
    flash[:notice] = 'Registrations are not open.'
    redirect_to new_user_session_path
  end
 
  def create
    flash[:notice] = 'Registrations are not open.'
    redirect_to new_user_session_path
  end

  protected

  def sign_up(resource_name, resource)
    true
  end   
    
  private 
 
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :payrate, :active, :role)
  end
 
  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :payrate, :active, :role, :current_password)
  end
end