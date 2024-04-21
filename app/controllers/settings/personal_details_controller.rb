module Settings
  class PersonalDetailsController < ApplicationController
    def edit
    end

    def update
      if Current.user.update(user_params)
        respond_to do |format|
          format.html { redirect_to edit_settings_personal_details_path, notice: "Personal details updated" }
          format.turbo_stream { flash.now[:notice] = "Personal details updated" }
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :handle, :timezone)
    end
  end
end
