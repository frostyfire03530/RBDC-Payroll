class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def after_sign_in_path_for(resource)
    if user_signed_in? && (current_user.role == 'user')
      user_timesheets_path(current_user.id)
    elsif user_signed_in? && (current_user.role == 'admin')
      users_path
    end
  end
  
  protected
  
  def after_update_path_for(resource)
      user_path(current_user.id)
  end
end
