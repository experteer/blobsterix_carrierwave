# encoding: utf-8

class $UploaderNameUploader < BlobsterixUploader

  # When setting a global process it is applied when 
  # uploaded to a blobsterix server
  #process :resize => ["", "300"]

  # This sets a directory inside a bucket
  # only used for cosmetic reasons
  #def store_dir
  #  "some_dir"
  #end

  # This function overrides the bucket set
  # in the carrierwave fog config
  # only use if this uploader should use a different bucket
  #def bucket
  #  "jobapp"
  #end

  # Versions work the same as in normal carrierwave
  # with the difference that versions are generated
  # on the server when requested and are not generated
  # when uploading
  #version :raw do
  #  process :resize => 100
  #  process :rotate => 25
  #  process :set_format => "raw"
  #end
  
  # This function is used to set the name of the file
  # on the server to something else than the actual upload
  # filename. So only use it when that behaviour is desired.
  # Example: It can be used to generate timestamped names
  #          to invalidate the client cache
  #def name_on_server
  #  "#{model.id}_#{Time.new.to_i}"
  #end
end