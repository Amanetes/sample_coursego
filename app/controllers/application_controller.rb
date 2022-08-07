# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_global_variables, if: :user_signed_in?
  protect_from_forgery
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  include PublicActivity::StoreController # save current_user using gem public_activity

  def set_global_variables
    @ransack_courses = Course.ransack(params[:courses_search], search_key: :courses_search) # navbar search
  end

  private

  # pundit
  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_back(fallback_location: root_path)
    # redirect_to(request.referer || root_path)
  end
end
