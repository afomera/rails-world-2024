class WistiaClient < ApplicationClient
  BASE_URI = "https://api.wistia.com/v1"

  def delete_media(media_id)
    delete("/medias/#{media_id}")
  end

  def find_media(media_id)
    get("/medias/#{media_id}")
  end
end
