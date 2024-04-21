class Article < ApplicationRecord
  has_rich_text :body

  has_one_attached :header_image, providers: [ :pexels ]
  has_one_attached :image, providers: [ :media_library ]

  has_one_attached :video, providers: [ :wistia ]
end
