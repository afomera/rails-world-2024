class PexelsClient < ApplicationClient
  BASE_URI = "https://api.pexels.com/v1"

  def search(query)
    get("/search", query: { query: query })
  end

  private

  def default_headers
    {
      "Authorization" => token,
      "Content-Type" => "application/json"
    }
  end
end
