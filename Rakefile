require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "suggester"
  gem.homepage = "http://github.com/chingor13/suggester"
  gem.license = "MIT"
  gem.summary = %Q{Extensible, cache-based auto-suggest server for ruby.}
  gem.description = %Q{Extensible, cache-based auto-suggest server for ruby. Includes refresh and replication support out of the box.}
  gem.email = "ching.jeff@gmail.com"
  gem.authors = ["Jeff Ching"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "suggester #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :db do 
  desc 'setup test activerecord databases'
  task :prepare do
    load File.join(File.dirname(__FILE__), 'test', 'test_helper.rb')
    if RUN_AR_TESTS
      fixture_sql = File.join(File.dirname(__FILE__), 'test', 'fixtures', 'books.sql')
      statements = open(fixture_sql).read.split(";")
      statements.compact!
      statements.each do |sql|
        sql.strip!
        ActiveRecord::Base.connection.execute(sql) unless sql.nil? || sql.empty?
      end
    end
  end
end

