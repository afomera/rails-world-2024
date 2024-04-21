json.extract! article, :id, :title, :header_image, :body, :created_at, :updated_at
json.url article_url(article, format: :json)
json.header_image url_for(article.header_image)
json.body article.body.to_s
