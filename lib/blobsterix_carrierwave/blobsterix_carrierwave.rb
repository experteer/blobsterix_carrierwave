# encoding: utf-8
module Blobsterix
  module CarrierWave
    #crazy version stuff not needed anymore
    def recreate_versions!
      # Do nothing
      # puts "Recreate versions"
    end

    def cache_versions!(new_file=nil)
      # Do nothing
      # puts "Cache versions"
    end

    def store_versions!(new_file=nil)
      # Do nothing
      # puts "Store versions"
    end

    def remove_versions!(new_file=nil)
      # Do nothing
      # puts "Remove versions"
    end

    def retrieve_versions_from_cache!(new_file=nil)
      # Do nothing
      # puts "retrieve_versions_from_cache: #{version_name}"
    end

    def retrieve_versions_from_store!(new_file=nil)
      # Do nothing
      # puts "retrieve_versions_from_store: #{new_file.inspect}, #{version_name}"
      super(new_file)
    end

    def process!(new_file=nil)
      # Do nothing
      # puts "Doing process for #{new_file.inspect} on #{self.inspect}"
    end

    def remote_process!(encrypt=true)
      if enable_processing
        #Deactivate conditional stuff
        # self.class.processors.each do |method, args, condition|
        #   if(condition)
        #     next if !(condition.respond_to?(:call) ? condition.call(self, :args => args, :method => method, :file => new_file) : self.send(condition, new_file))
        #   end
        #   puts "Do: #{method} with #{args.inspect}"
        #   trafos.send(method, *args)
        # end
        BlobsterixAdhocTransforms::Generator.new(:uploader => self,:trafos => self.class.processors.map{|method, args, condition|[method, args]}).transform(encrypt)
      else
        ""
      end
    end

    def remote_processors()
      # puts "Version: #{version_name}"
      if enable_processing and version_name
        current_processor = self.class
        remote_processor_array = []
        until current_processor.superclass == BlobsterixUploader
          remote_processor_array+=current_processor.processors.map{|method, args, condition|[method, args]}
          current_processor = current_processor.module_parent
        end
        remote_processor_array
      else
        []
      end
    end

    private
      #much important, very nice, wow
      def full_filename(for_file)
        #[remote_process!, for_file].join(".")
        for_file
      end

    #url call somehow broken so just call it directly
    # def url(options = {})
    #   file.url(options)
    # end
  end
end
