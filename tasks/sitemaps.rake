require File.join(File.dirname(__FILE__), '/../lib/ip/processor')

namespace :sitemap do

  desc "Generates the sitemap"
  task :generate do    
    require(File.join(RAILS_ROOT, 'config', 'environment'))
    output_directory = ENV['OUTPUT_DIRECTORY'] || RAILS_ROOT + '/public'
    host = ENV['HOST']
    processor = IP::Sitemap::Processor.new(output_directory, host)
    processor.process
  end

end
