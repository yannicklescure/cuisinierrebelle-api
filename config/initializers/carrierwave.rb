# CarrierWave.configure do |config|
#  config.cache_storage = :file
# end

CarrierWave.configure do |config|

  # Use AWS storage if in production
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     ENV['S3_KEY'],                # required unless using use_iam_profile
    aws_secret_access_key: ENV['S3_SECRET'],             # required unless using use_iam_profile
    use_iam_profile:       false,                         # optional, defaults to false
    region:                ENV['S3_REGION'],             # optional, defaults to 'us-east-1'
    host:                  ENV['S3_ASSET_URL'],            # optional, defaults to nil
    endpoint:              ENV['S3_CDN_URL'] # optional, defaults to nil
  }
  config.fog_directory  = ENV['S3_BUCKET_NAME']                                      # required
  config.fog_public     = false                                                 # optional, defaults to true
  config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
  # For an application which utilizes multiple servers but does not need caches persisted across requests,
  # uncomment the line :file instead of the default :storage.  Otherwise, it will use AWS as the temp cache store.
  # config.cache_storage = :file

  # if Rails.env.production?
  #   config.storage    = :aws
  #   config.aws_bucket = ENV['S3_BUCKET_NAME'] # for AWS-side bucket access permissions config, see section below
  #   # config.aws_acl    = 'private'
  #   config.aws_acl    = 'public_read'

  #   # Optionally define an asset host for configurations that are fronted by a
  #   # content host, such as CloudFront.
  #   config.asset_host = ENV['S3_CDN_URL']

  #   # The maximum period for authenticated_urls is only 7 days.
  #   config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

  #   # Set custom options such as cache control to leverage browser caching.
  #   # You can use either a static Hash or a Proc.
  #   config.aws_attributes = -> { {
  #     expires: 1.week.from_now.httpdate,
  #     cache_control: 'max-age=604800'
  #   } }

  #   config.aws_credentials = {
  #     access_key_id:     ENV['S3_KEY'],
  #     secret_access_key: ENV['S3_SECRET'],
  #     region:            ENV['S3_REGION'], # Required
  #     stub_responses:    Rails.env.test? # Optional, avoid hitting S3 actual during tests
  #   }

  #   # Optional: Signing of download urls, e.g. for serving private content through
  #   # CloudFront. Be sure you have the `cloudfront-signer` gem installed and
  #   # configured:
  #   # config.aws_signer = -> (unsigned_url, options) do
  #   #   Aws::CF::Signer.sign_url(unsigned_url, options)
  #   # end
  # end

end
