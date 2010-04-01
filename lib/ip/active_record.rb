module IP
  module Sitemap
    module ActiveRecord
 
      def self.included(base)
        base.class_eval do
          extend ClassMethods
 
          class_inheritable_accessor :sitemap_options
        end
      end
 
      module ClassMethods
        def sitemap(options = {})
          options.reverse_merge(:batch_size => 50000, 
                                :route => "#{self.class.to_s.underscore}_url")
          self.sitemap_options = options
        end
      end
    end
  end
end