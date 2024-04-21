json.array! @blobs do |blob|
  json.id blob.id
  json.filename blob.filename
  json.content_type blob.content_type
  json.created_at blob.created_at
end
