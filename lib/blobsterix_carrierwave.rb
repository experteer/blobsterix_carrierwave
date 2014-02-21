require "blobsterix_carrierwave/version"

require "carrierwave"
require "fog"

require "blobsterix_carrierwave/blobsterix_carrierwave"
require "blobsterix_carrierwave/blobsterix_storage"
require "blobsterix_carrierwave/blobsterix_transforms"
require "blobsterix_carrierwave/blobsterix_adhoc_transforms"
require "blobsterix_carrierwave/blobsterix_uploader"

module BlobsterixCarrierwave
  # Your code goes here...
  def self.encrypt_trafo(trafo_string)
    trafo_string
  end
end
