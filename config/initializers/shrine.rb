require 'shrine'
require 'shrine/storage/file_system'
#require 'shrine/storage/s3'

Shrine.plugin :activerecord
#Shrine.plugin :direct_upload
Shrine.plugin :logging, logger: Rails.logger

#s3_options = {
#  access_key_id:     Rails.application.secrets.aws_access_key_id,
#  secret_access_key: Rails.application.secrets.aws_secret_access_key,
#  region:            Rails.application.secrets.aws_region,
#  bucket:            Rails.application.secrets.aws_bucket,
#}

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
  store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store'),
  #cache: Shrine::Storage::S3.new(prefix: "cache", upload_options: {acl: "public-read"}, **s3_options),
  #store: Shrine::Storage::S3.new(prefix: "store", upload_options: {acl: "public-read"}, **s3_options),
}
