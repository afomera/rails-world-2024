# frozen_string_literal: true

class MediaComponent < ViewComponent::Base
  def initialize(blob:)
    @blob = blob
  end

  def photo_url
    if blob.image?
      Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true)
    elsif blob.service_name == "wistia"
      nil # show video icon
    else
      Rails.application.routes.url_helpers.url_for(blob)
    end
  end

  def filesize
    number_to_human_size(blob.byte_size) if blob.byte_size != 0
  end

  private

  attr_reader :blob

  def icon
    case blob.content_type
    when "video/mp4"
      '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
        <path stroke-linecap="round" stroke-linejoin="round" d="m15.75 10.5 4.72-4.72a.75.75 0 0 1 1.28.53v11.38a.75.75 0 0 1-1.28.53l-4.72-4.72M4.5 18.75h9a2.25 2.25 0 0 0 2.25-2.25v-9a2.25 2.25 0 0 0-2.25-2.25h-9A2.25 2.25 0 0 0 2.25 7.5v9a2.25 2.25 0 0 0 2.25 2.25Z" />
      </svg>'.html_safe
    end
  end
end
