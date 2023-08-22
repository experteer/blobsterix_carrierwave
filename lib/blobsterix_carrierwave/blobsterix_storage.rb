# encoding: utf-8
module CarrierWave
  module Storage
    class BlobsterixStore < Fog
      # From Abstract
      # attr_reader :uploader

      # def initialize(uploader)
      #    @uploader = uploader
      #    puts "Init BlobsterixStore"
      # end

      # def identifier
      #   uploader.filename
      # end

      #################
      # Abstract provides stubs we must implement.
      #
      # Create and save a file instance to your engine.
      def store!(file)
        # puts "Called store: #{file.inspect} with #{uploader.processors}"
        f = File.new(uploader, self, uploader.store_path)
        f.store(file)
        f
      end

      # Load and return a file instance from your engine.
      def retrieve!(identifier)
        File.new(uploader, self, uploader.store_path(identifier))
      end

      # Subclass or duck-type CarrierWave::SanitizedFile ; responsible for storing the file to your engine.
      class File < Fog::File
        def initialize(uploader, base, path)
          @uploader, @base, @path, @content_type = uploader, base, path, nil
        end

        def url(options = {})
          super(options)
        end

        def store(new_file)
          fog_file = new_file.to_file
          @content_type ||= new_file.content_type
          @file = directory.files.new({
            :body         => fog_file ? fog_file : new_file.read,
            :content_type => @content_type,
            :key          => path,
            :public       => @uploader.fog_public,
            :collection => directory.files,
            :service => directory.files.service
          }.merge(@uploader.fog_attributes))
          @file.metadata={"x-amz-meta-trafo" => @uploader.remote_process!(false)}
          @file.save()
          fog_file.close if fog_file && !fog_file.closed?
          true
        end

        def public_url
          @uploader.asset_host.url(encode_path(path))
        end

        def read
          @read ||= load_file_from_blobsterix
        end

        def load_file_from_blobsterix
          uri = URI(public_url)
          body = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
            response = http.get uri.path
            response.body
          end
          body || ""
        end

        def size
          read.present? ? read.size : 0
        end

        def delete
          super()
        end

        def exists?
          url = BlobsterixAdhocTransforms::Generator.new(:host => @uploader.fog_credentials[:connection_options][:proxy].gsub("http://",""), :uploader => @uploader, :path => @path).url_s3(nil, false)
          uri = URI(url)
          return_code = 404
          Net::HTTP.start(uri.host, uri.port) do |http|
            response = http.get uri.path # Net::HTTPResponse object
            response.code
          end == "200"
        end
        # Others... ?
        def process
        end

      end # File

    end # MyEngine
  end # Storage
end # CarrierWave
