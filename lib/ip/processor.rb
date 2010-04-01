require 'ruby-debug'
require 'action_view'
require 'action_controller'
require 'zlib'

module IP  
  module Sitemap
    
    class RouteMaker
      include Singleton
      include ::ActionController::UrlWriter      
      include ::ActionView::Helpers::TextHelper
      include ::ActionView::Helpers::UrlHelper
      include ::ActionView::Helpers::DateHelper
      include ::ActionView::Helpers::TagHelper
      include ::ActionView::Helpers::ActiveRecordHelper
      
      def set_host(host)
        self.class.default_url_options[:host] = host
      end       

    end
        
    class Processor
      
      attr_accessor :urlsets, :output_directory, :host
      
      def initialize(output_directory, host)
        self.urlsets = []
        self.output_directory = output_directory
        self.host = host
      end
    
      def sitemap_classes
        classes = ::ActiveRecord::Base.send(:subclasses).select{|klass| !klass.sitemap_options.nil? }
      end
    
      def process
        batch = 1
        sitemap_classes.each do |klass|
          klass.find_in_batches(:batch_size => klass.sitemap_options[:batch_size]).each do |group|
            xml = process_group(klass, group)
            filename = "/#{klass.to_s.underscore}_urlset_#{batch}.xml"
            filename += '.gz' if klass.sitemap_options[:compress]
            urlsets << filename
            create_file(filename, xml, klass)
            create_index_file
            batch += 1            
          end
        end        
      end
      
      def create_file(filename, xml, klass)
        if klass.sitemap_options[:compress]
          create_gz_file(filename, xml)
        else
          create_xml_file(filename, xml)
        end
      end
            
      def create_gz_file(filename, xml)
        ::Zlib::GzipWriter.open(output_directory + filename) do |gz|
          gz.write xml
        end
      end
      
      def create_xml_file(filename, xml)
        File.open(output_directory + filename, "w") do |file|
          file << xml
        end
      end
      
      def create_index_file
        sitemap_index = IP::Sitemap::SitemapIndex.new
        sitemap_index.sitemaps = []
        urlsets.each do |urlset|
          sitemap = IP::Sitemap::Sitemap.new
          sitemap.loc = host + urlset
          sitemap_index.sitemaps << sitemap
        end
        doc = ROXML::XML::Document.new
        doc.root = sitemap_index.to_xml
        doc.save(output_directory + '/sitemap_index.xml')
      end
      
      def process_group(klass, group)
        doc = ROXML::XML::Document.new
        urlset = IP::Sitemap::Urlset.new
        urlset.urls = []
        group.each do |instance|
          url = IP::Sitemap::Url.new
          IP::Sitemap::RouteMaker.instance.set_host(host)
          url.loc = IP::Sitemap::RouteMaker.instance.send(klass.sitemap_options[:route], instance)
          url.lastmod = instance.updated_at.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
          url.changefreq = klass.sitemap_options[:changefreq] || 'daily'
          url.priority = klass.sitemap_options[:priority] || instance.try(:priority) || 1
          urlset.urls << url
        end
        doc.root = urlset.to_xml
        doc.to_s
      end          
    end
  end
end
