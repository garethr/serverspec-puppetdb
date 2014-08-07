require 'rake'
require 'rspec/core/rake_task'
require 'puppetdb'

task :spec    => 'spec:all'
task :default => :spec

PUPPETDB_ADDRESS = ENV['PUPPETDB_ADDRESS'] || 'http://localhost:18080'

namespace :spec do
  desc "Run serverspec tests against all nodes"

  targets = []

  client = PuppetDB::Client.new({:server => PUPPETDB_ADDRESS})
  response = client.request('facts', [:'=', 'name', 'ipaddress_eth1'])

  response.data.each do |node|
    targets << {:name => node['certname'], :ip => node['value']}
  end

  task :all => targets.map { |node| node[:name] }
  task :default => :all

  targets.each do |target|
    desc "Run serverspec tests on #{target[:name]}"
    RSpec::Core::RakeTask.new(target[:name].to_sym) do |t|
      ENV['TARGET_HOST'] = target[:ip]
      ENV['PUPPETDB'] = PUPPETDB_ADDRESS
      ENV['TARGET_NAME'] = target[:name]
      t.pattern = "spec/*_spec.rb"
    end
  end
end
