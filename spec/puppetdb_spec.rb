require 'spec_helper'
require 'puppetdb'

class PuppetdbServerspecGenerator
  include Serverspec::Helper::Type

  def initialize
    @client = PuppetDB::Client.new({:server => ENV['PUPPETDB']})
  end

  def test_type(type)
    response = @client.request('resources', [:and,
                                              [:'=', 'type', type.capitalize],
                                              [:'=', 'certname', ENV['TARGET_NAME']]])

    response.data.each do |item|
      name = item['parameters']['name'] || item['title']
      RSpec.describe send(type, name) do
        case type
        when 'package'
          it { should be_installed }
        when 'service'
          it { should be_enabled }
          it { should be_running }
        when 'user', 'group'
          it { should exist }
        end
      end
    end

  end
end

generator = PuppetdbServerspecGenerator.new

generator.test_type('package')
generator.test_type('service')
generator.test_type('user')
generator.test_type('group')
