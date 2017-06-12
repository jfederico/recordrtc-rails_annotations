class VideoUploader < Shrine
  plugin :determine_mime_type
  plugin :validation_helpers

  Attacher.validate do
    validate_mime_type_inclusion ['video/webm']
  end
end
