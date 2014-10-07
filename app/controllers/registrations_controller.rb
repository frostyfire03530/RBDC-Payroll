class RegistrationsController < Devise::RegistrationsController
 
  def create
    super #Nothing special here.
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