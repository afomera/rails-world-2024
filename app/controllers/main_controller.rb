class MainController < ApplicationController
  def index
    flash.now[:notice] = "Hello, Rails!"
  end
end
