class MediaLibrary::DownloadRedirectsController < ApplicationController
  def show
    @blob = ActiveStorage::Blob.find(params[:id])

    if @blob.service_name == "wistia"
      redirect_to wistia_download_url, allow_other_host: true
    else
      redirect_to rails_blob_path(@blob, disposition: "attachment", only_path: true)
    end
  end

  private

  def filename
    @blob.filename
  end

  def wistia_download_url
    URI::HTTPS.build(
      host: "embed.wistia.com",
      path: download_path,
      query: {disposition: :attachment}.to_query
    ).to_s
  end

  def download_path
    download_uri.path.gsub(File.extname(download_uri.path), "/#{parameterized_filename}")
  end

  def parameterized_filename
    "#{filename.base.parameterize}#{filename.extension_with_delimiter}"
  end

  def download_uri
    @download_uri ||= URI(wistia_media.assets.first["url"]) # should be OriginalFile asset type
  end

  def wistia_media
    @wistia_media ||= WistiaClient.new(token: Rails.application.credentials.dig(:wistia, :api_token)).find_media(@blob.key)
  end
end
