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
        # puts "Called retrieve: #{identifier.class}:#{identifier}"
        File.new(uploader, self, uploader.store_path(identifier))
      end

      # Subclass or duck-type CarrierWave::SanitizedFile ; responsible for storing the file to your engine.
      class File < Fog::File
        def initialize(uploader, base, path)
          @uploader, @base, @path = uploader, base, path
        end

        def url(options = {})
          # puts "Get file url: #{options}, #{@uploader.version_name}"
          u = super(options)
          # puts "Url is now: #{u}"
          u
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
            :connection => directory.files.connection
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
          super()
        end
        def size
          super()
        end
        def delete
          super()
        end
        def exists?
          url = BlobsterixAdhocTransforms::Generator.new(:host => @uploader.fog_credentials[:connection_options][:proxy].gsub("http://",""), :uploader => @uploader, :path => @path).url_s3(nil, false)
          # puts "Check url: #{url}"
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