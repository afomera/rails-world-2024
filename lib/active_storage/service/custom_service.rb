class ActiveStorage::Service::CustomService < ActiveStorage::Service
  def upload(key, io, checksum: nil, **options)
    raise NotImplementedError
  end

  def delete(key)
    raise NotImplementedError
  end

  def download(key)
    raise NotImplementedError
  end

  def download_chunk(key, range)
    raise NotImplementedError
  end

  def public?
    raise NotImplementedError
  end

  private

  # Depending on public? and the service's capabilities, return a public URL or a private URL for the file at the +key+.
  def private_url(key, expires_in:, filename:, disposition:, content_type:, **)
    raise NotImplementedError
  end

  # Return a public URL for the file at the +key+.
  def public_url(key, **)
    raise NotImplementedError
  end
end
