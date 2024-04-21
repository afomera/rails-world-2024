module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user

    helper_method :user_signed_in?
  end

  private

  def user_signed_in?
    Current.user.present?
  end

  def authenticate_user!
    if Current.user.nil?
      redirect_to new_session_path, alert: "Log in to continue."
    end
  end

  def redirect_if_authenticated
    if user_signed_in?
      redirect_to root_path
    end
  end

  def set_current_user
    if (authenticated_user = User.find_signed(cookies.signed[:session_token], purpose: :session_token))
      Current.user = authenticated_user
    end
  end

  def login(user)
    cookies.signed[:session_token] = {
      value: user.signed_id(purpose: :session_token, expires_in: 14.days),
      expires: 14.days
    }
  end

  def logout
    cookies.delete(:session_token)
    reset_session
    Current.user = nil
  end

  # Called after a user registers successfully.
  def after_registration(user)
    login(user)

    # TODO: Implement email confirmation
    # UserMailer.with(user: user).email_confirmation.deliver_later!
  end
end
