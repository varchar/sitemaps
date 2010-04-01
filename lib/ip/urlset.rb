require 'roxml'
module IP
  module Sitemap
    
    class Sitemap
      include ROXML
      xml_accessor :loc
    end
        
    class Url
      include ROXML
      xml_accessor :loc
      xml_accessor :lastmod, :as => Date
      xml_accessor :changefreq
      xml_accessor :priority, :as => Float
    end

    class Urlset
      include ROXML
      xml_name :urlset
      xml_accessor :xmlns, :from => '@xmlns'
      xml_accessor :urls, :as => [IP::Sitemap::Url]
    
      def xmlns
        "http://www.sitemaps.org/schemas/sitemap/0.9"
      end    
    end
    
    class SitemapIndex
      include ::ROXML
      xml_name :sitemapindex
      xml_accessor :sitemaps, :as => [IP::Sitemap::Sitemap]
    end    
  
  end
end