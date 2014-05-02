require "blobsterix_carrierwave/version"

require "carrierwave"
require "fog"

require "blobsterix_carrierwave/blobsterix_carrierwave"
require "blobsterix_carrierwave/blobsterix_storage"
require "blobsterix_carrierwave/blobsterix_transforms"
require "blobsterix_carrierwave/blobsterix_adhoc_transforms"
require "blobsterix_carrierwave/blobsterix_uploader"
require "blobsterix_carrierwave/blobsterix_uploader_version" #monkey patch instance naming

module BlobsterixCarrierwave
  # Your code goes here...
  def self.encrypt_trafo(trafo_string=nil, generator=nil)
    @encrypt_trafo||=lambda{|t_string, generator| t_string}
    trafo_string ? @encrypt_trafo.call(trafo_string, generator) : @encrypt_trafo
  end

  def self.encrypt_trafo=(obj)
    @encrypt_trafo=obj
  end
end
