class WistiaClient < ApplicationClient
  BASE_URI = "https://api.wistia.com/v1"

  def self.delete_media(media_id)
    new(token: Rails.application.credentials.dig(:wistia, :api_token)).delete_media(media_id)
  end

  def self.find_media(media_id)
    new(token: Rails.application.credentials.dig(:wistia, :api_token)).find_media(media_id)
  end

  def delete_media(media_id)
    delete("/medias/#{media_id}")
  end

  def find_media(media_id)
    get("/medias/#{media_id}")
  end
end
