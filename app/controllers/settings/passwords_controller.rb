module Settings
  class PasswordsController < ApplicationController
    before_action :set_user

    def edit
    end

    def update
      if @user.update(user_params)
        respond_to do |format|
          format.html { redirect_to settings_url, notice: "Password updated" }
          format.turbo_stream { flash.now[:notice] = "Password updated" }
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user ||= Current.user
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation, :password_challenge).with_defaults(password_challenge: "")
    end
  end
end
