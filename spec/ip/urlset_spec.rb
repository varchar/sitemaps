require File.dirname(__FILE__) + './../lib/ip/urlset'

describe IP::Sitemap::Urlset do
  before(:each) do
    fixture_path = File.dirname(__FILE__)  + './../spec/resources'
    @xml = File.read(fixture_path + '/sitemap.xml')
  end
  
  it "#from_xml should parse the sitemap.xml file" do
    urlset = IP::Sitemap::Urlset.from_xml(@xml)
    url = urlset.urls.first
    url.loc.should == 'http://www.example.com/'
    url.lastmod.to_s.should == '2005-01-01'
    url.changefreq.should == 'monthly'
    url.priority.should == 0.8
  end
  
  it "#to_xml should create xml" do
    urlset = IP::Sitemap::Urlset.new
    url = IP::Sitemap::Url.new
    url.loc = 'http://www.example.com/'
    url.lastmod = Date.new(2005,1,1)
    url.changefreq = 'monthly'
    url.priority = 0.8    
    urlset.urls = [url]
    urlset.to_xml.to_s.should == "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n  <url>\n    <loc>http://www.example.com/</loc>\n    <lastmod>2005-01-01</lastmod>\n    <changefreq>monthly</changefreq>\n    <priority>0.8</priority>\n  </url>\n</urlset>"
  end
end