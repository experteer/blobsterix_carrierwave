# encoding: utf-8
class BlobsterixUploader < CarrierWave::Uploader::Base

  include CarrierWave::MimeTypes
  include Blobsterix::CarrierWave

  #storage :file
  storage CarrierWave::Storage::BlobsterixStore

  include BlobsterixTransforms

  after :store, :done_store
  before :store, :before_store

  def before_store obj
    #puts "Start with storing"
  end
  def done_store obj
    #puts "Done with storing"
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    #puts "Would say: uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    "images"
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def fog_directory
    bucket || super()
  end

  def bucket
    nil
  end

  def custom
    asset_host.set_path(path).clear_trafo
  end

  def filename
    if original_filename.present? and respond_to?(:name_on_server)
      name_on_server
    else
      super()
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  #process :scale => ["", "300"]
  #process :rotate => 45
  #



  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, "50!"]
  # end

  # version :face do
  #   process :scale => [10, 10]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end