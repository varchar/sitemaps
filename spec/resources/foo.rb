class Foo
  
  def self.sitemap_options
    {:batch_size => 50000, :route => :test_route_url, :priority => 2}
  end
  
  def self.find_in_batches(options = {})
    [[Foo.new]]
  end
  
  def updated_at
    DateTime.new(12,12,12) # Mon, 12 Dec 0012 00:00:00 +0000
  end
  
end