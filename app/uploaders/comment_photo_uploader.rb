class CommentPhotoUploader < CarrierWave::Uploader::Base
  after :store, :delete_old_tmp_file

  include Piet::CarrierWaveExtension

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  # include CarrierWave::WebP::Converter
  include WebPConverter

  # Choose what kind of storage to use for this uploader:
  if Rails.env.development? || Rails.env.test?
    storage :file
  elsif Rails.env.production?
    # storage :fog
    storage :aws
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  # def store_dir
  #   "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # process eager: true
  # process convert: 'jpg'

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # process optimize: [{quality: 90, level: 7}]
  # process convert_to_webp: [{ quality: 60, method: 6 }]

  # version :webp do
  #   process convert_to_webp: [{ quality: 80, method: 5 }]

  #   def full_filename(file)
  #     return "#{version_name}_#{file}" if file.split('.').last == 'webp'

  #     "#{version_name}_#{file}.webp"
  #   end
  # end

  version :thumb do
    # process resize_to_fill: [64, 64]
    process efficient_conversion: [64, 64]
    process convert_to_webp: [{ quality: 60, method: 6 }]
    def full_filename(file)
      return "#{version_name}_#{file}" if file.split('.').last == 'webp'
      "#{version_name}_#{file}.webp"
    end
  end

  version :preview do
    # process resize_to_fill: [260, 174]
    process efficient_conversion: [260, 174]
    process convert_to_webp: [{ quality: 60, method: 6 }]
    def full_filename(file)
      return "#{version_name}_#{file}" if file.split('.').last == 'webp'
      "#{version_name}_#{file}.webp"
    end
  end

  version :card do
    # process resize_to_fill: [400, 300]
    process efficient_conversion: [400, 300]

  end

  version :open_graph do
    # process resize_to_fill: [1200, 1200]
    # process efficient_conversion: [1200, 1200]
    # process convert_to_webp: [{ quality: 60, method: 6 }]
    # def full_filename(file)
    #   return "#{version_name}_#{file}" if file.split('.').last == 'webp'
    #   "#{version_name}_#{file}.webp"
    # end
    process efficient_conversion: [1200, 1200]
    process convert: 'jpg'
  end

  version :full do
    # process resize_to_fill: [1920, 1200]
    process efficient_conversion: [1920, 1200]
    process convert_to_webp: [{ quality: 60, method: 6 }]
    def full_filename(file)
      return "#{version_name}_#{file}" if file.split('.').last == 'webp'
      "#{version_name}_#{file}.webp"
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_allowlist
    %w(JPG jpg jpeg gif png)
  end

  def content_type_allowlist
    /image\//
  end

  def content_type_denylist
    ['application/text', 'application/json']
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  def filename
    # super.chomp(File.extname(super)) + '.jpg' if original_filename.present?
    # "#{secure_token}.#{file.extension.downcase}" if original_filename.present?
    "#{secure_token}.jpg" if original_filename.present?
  end

  def sanitized_file
    super
  end

  # remember the tmp file
  def cache!(new_file = sanitized_file)
    super
    @old_tmp_file = new_file
  end

  def delete_old_tmp_file(dummy)
    @old_tmp_file.try :delete
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

  def efficient_conversion(width, height)
    manipulate! do |img|
      img.format("jpg") do |c|
        c.fuzz        "3%"
        c.trim
        c.resize      "#{width}x#{height}>"
        c.resize      "#{width}x#{height}<"
      end
      img
    end
  end
end
