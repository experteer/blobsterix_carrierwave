# encoding: utf-8
module BlobsterixAdhocTransforms
  extend BlobsterixTransforms
    class Generator
      def initialize(options={})
        # host
        # bucket
        # path
        # trafos <- array with transform methods and 
        # uploader <- BlobsterixCarrierWaveUploader
        @options = options || {}
        @chain=[]

        # activate relative ssl protocoll as standard option
        @options[:relative_ssl] = true unless @options.has_key?(:relative_ssl)

        #init the trafos
        (@options[:trafos] || []).each{|t|
          self.send(t[0], t[1])
        }
      end

      def clear_trafo
        @chain = []
        self
      end

      def set_path(path)
        @options[:path] = path
        self
      end

      def query(args={})
        query_options.merge!(args)
        self
      end

      def url(path=nil)
        @options[:path] = path if path
        "#{asset_host}#{encoded_path}#{query_options_string}"
      end

      def url_s3(path=nil, use_subdomain=true)
        @options[:path] = path if path

        "#{s3_host(use_subdomain)}#{encoded_path}"
      end

      def transform(encrypt=true)
        trafo = @chain.map{|trafo|
          "#{trafo[:method]}_#{trafo[:args]}"
        }.join(",")
        encrypt ? BlobsterixCarrierwave.encrypt_trafo(trafo, self) : trafo
      end

      def has_transform?
        !@chain.empty?
      end

      def method_missing(method, *args)
        if BlobsterixAdhocTransforms.respond_to?(method)
          @chain << BlobsterixAdhocTransforms.send(method, *args)
        elsif uploader && uploader.respond_to?(method)
          specific_trafo = uploader.send(method, *args)
          @chain << specific_trafo if specific_trafo && specific_trafo.kind_of?(Hash)
        end
        self
      end

      def uploader
        @options[:uploader]
      end

      private
        def version
          @options[:version] || 1        
        end
        def encoded_path
          @options[:path] || ""
        end
        def s3_host(use_subdomain)
          if (use_subdomain)
            "http://#{bucket}.#{@options[:host]}/"
          else
            "http://#{@options[:host]}/#{bucket}/"
          end
        end
        def http
          @options[:ssl] ? "https:" : (@options[:relative_ssl] ? "" : "http:")
        end
        def asset_host

          host = @options[:host] || ""
          if host.respond_to? :call and @options.has_key?(:uploader)
            host.call(self)
          else
            trafo = transform
            if trafo.length > 0
              "#{http}//#{host}/blob/v#{version}/#{trafo}.#{bucket}/"
            else
              "#{http}//#{host}/blob/v#{version}/#{bucket}/"
            end
          end

          #"http://localhost:9000/blob/v1/#{trafo}.#{uploader.fog_directory}/"
        end
        def query_options
          @query||={}
        end
        def query_options=(opts={})
          @query=opts
        end
        def query_options_string
          puts "Query!!!!!: #{query_options.inspect}"
          if uploader.respond_to?(:force_filename)
            if query_options.empty?
              "?filename=#{uploader.force_filename}"
            else
              "?filename=#{uploader.force_filename}&#{query_options.map {|i,v| "#{i}=#{v}" }.join("&")}"
            end
          else
            if query_options.empty?
              ""
            else
              "?#{query_options.map {|i,v| "#{i.to_s}=#{v.to_s}" }.join("&")}"
            end
          end
        end
        def bucket()
          if @options.has_key?(:uploader)
            @options[:uploader].fog_directory
          else
            @options[:bucket] || "main"
          end
        end
    end
  end