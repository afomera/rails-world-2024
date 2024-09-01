module ApplicationHelper
  def custom_form_with(options = {}, &block)
    options.reverse_merge!(builder: CustomFormBuilder)

    form_with(**options, &block)
  end

  def render_turbo_stream_flash_messages
    turbo_stream.append "flash_messages", partial: "shared/flash"
  end

  def classes_for_flash(flash_key)
    case flash_key.to_s
    when "error"
      "bg-red-600 text-white"
    else
      "bg-black text-white"
    end
  end

  def render_video(video_blob)
    video_blob = video_blob.blob if video_blob.respond_to?(:blob)

    tag.div(class: "wistia_responsive_padding", style: "padding:56.25% 0 0 0; position:relative;") do
      tag.div(class: "wistia_responsive_wrapper", style: "height:100%; left:0; position:absolute; top:0; width:100%;") do
        tag.div(class: "wistia_embed wistia_async_#{video_blob.key}", style: "width:100%; height:100%;")
      end
    end
  end
end
