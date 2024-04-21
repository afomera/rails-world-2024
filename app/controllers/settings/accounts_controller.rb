module Settings
  class AccountsController < ApplicationController
    before_action :set_user

    def edit
    end

    private

    def set_user
      @user ||= Current.user
    end
  end
end
