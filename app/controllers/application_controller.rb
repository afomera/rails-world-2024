class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Authentication

  before_action :authenticate_user!
  before_action :set_current_details

  private

  def set_current_details
    Current.timezone = Current.user.timezone if Current.user.present?
  end
end
