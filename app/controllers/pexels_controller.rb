class PexelsController < ApplicationController
  def search
    api_key = Rails.application.credentials.dig(:pexels, :api_key)
    query = params[:query]

    response = PexelsClient.new(token: api_key).search(query)
    response = response.photos.map do |photo|
      {
        id: photo.id,
        description: photo.description,
        url: photo.src.original,
        user: photo.photographer,
        user_url: photo.photographer_url
      }
    end

    render json: response
  end
end
