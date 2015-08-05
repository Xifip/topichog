CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
    aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    region: 'eu-west-1'
  }
  config.fog_directory = "topichogire"

  config.fog_public     = false                                   # optional, defaults to true
  config.fog_authenticated_url_expiration = 600
  config.fog_attributes = {ssl_version: :TLSv1_2}
  #config.max_file_size     = 700.kilobytes
  #config.fog_directory = ENV["AWS_S3_BUCKET"]
  #config.fog_host = 'https://s3-eu-west-1.amazonaws.com/topichogire'
end
