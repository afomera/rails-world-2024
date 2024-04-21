# We're purposefully overriding has_one_attached to allow us to pass additional providers to the uploader.
# The Uploader front end sends back starts with "pexels:" which comes from choosing an Pexels image in our uploader
# Alternatively, the Uploader front end sends back starts with "wistia:" which comes from uploading a Wistia video in the _form.html.erb
require "open-uri"

module ActiveStorage::Providers
  extend ActiveSupport::Concern

  @@providers = {}

  # has_one_attached :logo, providers: [:pexels, :media_library]
  # has_one_attached :video, providers: [:wistia]

  class_methods do
    def has_one_attached(name, dependent: :purge_later, service: nil, strict_loading: false, **options)
      if options[:providers].present?
        add_hooks(name)
        @@providers[self.name] = @@providers.fetch(self.name, {})
        @@providers[self.name][name.to_sym] = Array.wrap(options[:providers])
      end

      super(name, dependent: dependent, service: service, strict_loading: strict_loading)
    end

    def add_hooks(name)
      define_method(:"#{name}=") do |value|
        if self.class.providers_for(name) && value.is_a?(String) && value.start_with?("pexels:")
          super(create_pexels_blob(value))
        elsif self.class.providers_for(name) && value.is_a?(String) && value.start_with?("wistia:")
          super(create_wistia_blob(value))
        else
          super(value)
        end
      end
    end

    def providers_for(name)
      @@providers.fetch(base_class.to_s, {}).fetch(name.to_sym, [])
    end
  end

  private

  def create_pexels_blob(value)
    url = value.split("pexels:").last

    # Download the image from Pexels
    filename = File.basename(URI.parse(url).path)
    file = OpenURI.open_uri(url)
    content_type = Marcel::MimeType.for(file.path)

    # Create a new blob
    blob = ActiveStorage::Blob.create_and_upload!(
      io: file,
      filename: filename,
      content_type: content_type,
      metadata: { "pexels" => true }
    )

    blob
  end

  def create_wistia_blob(value)
    # wistia:hashedId:filename
    _service, wistia_id, filename = value.split(":")

    # Create a new blob
    blob = ActiveStorage::Blob.create(
      byte_size: 0,
      key: wistia_id,
      checksum: Digest::MD5.hexdigest(wistia_id),
      filename: filename,
      content_type: Marcel::MimeType.for(filename),
      service_name: "wistia",
      metadata: { "wistia" => true }
    )

    blob
  end
end
