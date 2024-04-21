# # Monkey patch ActiveStorage::Attachment
ActiveSupport.on_load(:active_storage_attachment) do
  ActiveStorage::Attachment.include ActiveStorage::UserAttachment
end

ActiveSupport.on_load(:active_storage_blob) do
  ActiveStorage::Blob.include ActiveStorage::WistiaBlob
  ActiveStorage::Blob.include ActiveStorage::Scopes
end
