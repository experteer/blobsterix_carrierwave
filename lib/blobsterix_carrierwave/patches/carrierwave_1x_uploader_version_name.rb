# encoding: utf-8

module CarrierWave
  module Uploader
    module ClassMethods
      def version(name, options = {}, &block)
        uploader = Class.new(self)
        const_set("Uploader#{name.to_s.gsub('-', '_')}", uploader) # Set the version-specific class name
        uploader.version_names = [name.to_s]
        uploader.versions = {}
        uploader.processors = []

        uploader.class_eval do
          define_singleton_method(:enable_processing) do |value = nil|
            self.enable_processing = value unless value.nil?
            @enable_processing.nil? ? superclass.enable_processing : @enable_processing
          end

          define_method(:move_to_cache) do
            false
          end
        end

        uploader.class_eval(&block) if block_given?

        define_method(name) do
          versions[name.to_sym]
        end

        current_version = {
          name.to_sym => {
            uploader: uploader,
            options: options
          }
        }
        self.versions = versions.merge(current_version)
      end
    end
  end
end
