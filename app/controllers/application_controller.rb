# frozen_string_literal: true

class ApplicationController < ActionController::Base
  
  protect_from_forgery with: :exception

  # skip_before_action :require_user!, only: [:sign_in]

  include Passwordless::ControllerHelpers

  helper_method :current_user

  private

  def current_user
    @current_user ||= authenticate_by_session(User)
  end

  def require_user!
    unless current_user
      redirect_to auth.sign_in_path
    end
  end
end
