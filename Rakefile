require 'rubygems'
require 'rake'
require 'tasks/rails'
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "easy-sitemaps"
    gem.summary = %Q{Easy Sitemaps for Rails}
    gem.email = "charlesmbowman@gmail.com"
    gem.homepage = "http://github.com/varchar/foo"
    gem.authors = ["varchar", "robustdj"]
    gem.add_development_dependency "rspec", ">= 1.2.0"
    gem.add_development_dependency "roxml", ">= 3.0"
    gem.add_development_dependency "action_view", ">= 2.3.2"    
    gem.add_development_dependency "action_controller", ">= 2.3.2"        
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Sitemaps #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
