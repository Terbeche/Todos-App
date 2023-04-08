class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :authenticate_user!, unless: -> { request.path_info =~ /\/users/ }
  
    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
    end
  
    def after_sign_in_path_for(resource)
      todos_path
    end
  end
  