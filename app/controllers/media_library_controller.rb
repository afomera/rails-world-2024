class MediaLibraryController < ApplicationController
  def index
    @search = params[:search]

    @blobs = ActiveStorage::Blob.search_by_filename(@search).order(created_at: :desc).joins(:attachments).where(attachments: { user_id: Current.user.id })

    ActiveStorage::Current.url_options = { host: "localhost", port: 3000 }

    if params[:type].present?
      @blobs = @blobs.select { |blob| blob.content_type.start_with?(params[:type]) }
    end

    respond_to do |format|
      format.html
      format.json { render json: @blobs.as_json(only: %i[id filename content_type byte_size created_at], methods: [:url, :signed_id]) }
    end
  end

  def destroy
    @blob = ActiveStorage::Blob.find(params[:id])
    @blob.attachments.each(&:purge_later)

    respond_to do |format|
      format.html { redirect_to media_library_url, notice: "File was successfully deleted." }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@blob) }
    end
  end
end
