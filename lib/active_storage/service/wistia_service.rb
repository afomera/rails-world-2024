class ActiveStorage::Service::WistiaService < ActiveStorage::Service
  def upload(key, io, checksum: nil, **options)
    # no-op, upload is handled via the front-end Wistia Uploader
  end

  def delete(key)
    # TODO: Move this to a background job
    WistiaClient.delete_media(key)
  end

  def download(key)
    # no-op
  end

  def download_chunk(key, range)
    # no-op
  end

  def public?
    true
  end
end
