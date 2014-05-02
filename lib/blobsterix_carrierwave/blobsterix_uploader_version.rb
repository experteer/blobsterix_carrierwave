# encoding: utf-8

module CarrierWave
  module Uploader
    module Versions
      module ClassMethods
        def version(name, options = {}, &block)
          name = name.to_sym
          unless versions[name]
            uploader = Class.new(self)
            const_set("Uploader#{name}".gsub('-', '_'), uploader)
            uploader.versions = {}

            # Define the enable_processing method for versions so they get the
            # value from the parent class unless explicitly overwritten
            uploader.class_eval <<-RUBY, __FILE__, __LINE__ + 1
              def self.enable_processing(value=nil)
                self.enable_processing = value if value
                if !@enable_processing.nil?
                  @enable_processing
                else
                  superclass.enable_processing
                end
              end
            RUBY

            # Regardless of what is set in the parent uploader, do not enforce the
            # move_to_cache config option on versions because it moves the original
            # file to the version's target file.
            #
            # If you want to enforce this setting on versions, override this method
            # in each version:
            #
            # version :thumb do
            #   def move_to_cache
            #     true
            #   end
            # end
            #
            uploader.class_eval <<-RUBY
              def move_to_cache
                false
              end
            RUBY

            # Add the current version hash to class attribute :versions
            current_version = {}
            current_version[name] = {
              :uploader => uploader,
              :options  => options
            }
            self.versions = versions.merge(current_version)

            versions[name][:uploader].version_names += [name]

            class_eval <<-RUBY
              def #{name}
                versions[:#{name}]
              end
            RUBY
            # as the processors get the output from the previous processors as their
            # input we must not stack the processors here
            versions[name][:uploader].processors = versions[name][:uploader].processors.dup
            versions[name][:uploader].processors.clear
          end
          versions[name][:uploader].class_eval(&block) if block
          versions[name]
        end
      end
    end
  end
end