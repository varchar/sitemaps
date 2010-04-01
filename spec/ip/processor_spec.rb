require File.dirname(__FILE__)  + './../spec/resources/foo'
require File.dirname(__FILE__) + './../lib/ip/urlset'
require File.dirname(__FILE__) + './../lib/ip/processor'

describe IP::Sitemap::Processor do
  before(:each) do
    fixture_path = File.dirname(__FILE__)  + './../spec/resources'
    @xml = File.read(fixture_path + '/sitemap.xml')
    @processor = IP::Sitemap::Processor.new(File.dirname(__FILE__)  + './../spec/resources/public','http://www.insiderpages.com')
    @route_maker = IP::Sitemap::RouteMaker.instance
    @route_maker.stub!(:test_route_url).and_return("foo")
  end
  
  it "should have an output directory" do
    @processor.output_directory.should == File.dirname(__FILE__)  + './../spec/resources/public'
  end
  
  it "should return the urlset for the sitemap class" do
    @processor.process_group(Foo, [Foo.new]).should == "<?xml version=\"1.0\"?>\n<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n  <url>\n    <loc>foo</loc>\n    <lastmod>0012-12-12T00:00:00+00:00</lastmod>\n    <changefreq>daily</changefreq>\n    <priority>2</priority>\n  </url>\n</urlset>\n"
  end
  
  it "should generate a file for each batch of urlsets" do
    @processor.stub!(:sitemap_classes).and_return([Foo])
    @processor.process
    @processor.urlsets.should == ["/foo_urlset_1.xml"]
  end    
  
  it "should write the xml file" do
    @processor.stub!(:sitemap_classes).and_return([Foo])
    @processor.process
    File.exists?(File.dirname(__FILE__)  + './../spec/resources/public' + @processor.urlsets.first).should == true      
  end
  
  it "should generate the sitemap_index file" do
    @processor.stub!(:sitemap_classes).and_return([Foo])
    @processor.process
    File.exists?(File.dirname(__FILE__)  + './../spec/resources/public' + '/sitemap_index.xml').should == true
    xml = File.read(File.dirname(__FILE__)  + './../spec/resources/public' + '/sitemap_index.xml')
    IP::Sitemap::SitemapIndex.from_xml(xml).sitemaps.first.loc.should == "http://www.insiderpages.com/foo_urlset_1.xml"
  end
  
  it "should gzip the urlsets" do
    Foo.sitemap_options[:compress] = true
    @processor.stub!(:sitemap_classes).and_return([Foo])
    @processor.process
    File.exists?(File.dirname(__FILE__)  + './../spec/resources/public' + '/foo_urlset_1.xml.gz').should == true    
  end
end