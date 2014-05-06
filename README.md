# BlobsterixCarrierwave

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'blobsterix_carrierwave'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blobsterix_carrierwave

## Usage

Setup:
  # Configuration to setup carrierwave. This is needed for everything to work
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',                        # required
      :aws_access_key_id      => 'xxx',                        # required
      :aws_secret_access_key  => 'yyy',                        # required
      :region                 => 'eu-west-1',                  # optional, defaults to 'us-east-1'
      :host                   => 'blob.localhost.local',      # this hast to have 3 levels so the s3 libs can split them, won't ever be used
      :connection_options     => {:proxy => "http://#{Pjpp.config.blobsterix_upload_host_port}" }, #need a proxy as the s3 interface uses hostnames
                                                                                                   #won't mess with dynamic DNS, THIS IS THE REAL upload host
      :endpoint               => "http://blob.localhost.local" # same as host, won't ever be used
    }
    config.fog_directory  = 'pjpp'                     # required, can be overridden in each uploader
    config.fog_public     = true                                   # optional, defaults to true, and actually not used here anymore.
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
    config.delete_tmp_file_after_storage = true
    config.remove_previously_stored_files_after_update = true
    config.asset_host = proc do |uploader|
      BlobsterixAdhocTransforms::Generator.new(:host => Pjpp.config.blobsterix_host_port, :uploader => uploader, :trafos => uploader.remote_processors)
    end
  end

  # Simple uploader. Image is scaled to fit hight restriction, converted to png and stripped of all commentary data during upload
  # Now during download it offers three version. One without any transformation which will allow blobsterix to decide what is the best content type.
  # In case of images Chrome user would get webp images. The raw version restricts blobsterix to deliver the image in the same format it is saved on the server.
  # And in case of the crazy version it will rotate the image and then convert to best format again since its not locked.
  # The usage of the uploader is like the normal carrierwave.
  class CompanyLogoUploader < BlobsterixUploader

    process :resize => ["", "300"]
    process :strip
    process :set_format => "png"

    def store_dir
      "company_logos"
    end

    def bucket
      "jobapp"
    end

    version :raw do
      process :set_format => "raw"
    end

    version :crazy do
      process :rotate => 25
    end
    
    def name_on_server
      "#{model.id}_#{Time.new.to_i}"
    end
  end

  # Since the transformations are done on the fly and not in the application during upload, the uploader also allows custom transforms that do not have to be hardcoded.
  # instead of:

    company_logo.raw.url

  # you can do

    company_logo.custom.resize(200).rotate(25).url

  # this will generate the url and blobsterix will generate the image on the fly.

## Patches

In case you want to recreate uploader from saved instances you need fixed class names. To achieve this simply do:

  require "blobsterix_carrierwave/patches/carrierwave_090_uploader_version_name"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
