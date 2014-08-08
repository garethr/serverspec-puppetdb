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
          it { should be_installed } if item['parameters']['ensure'] == 'installed'
          it { should_not be_installed } if item['parameters']['ensure'] == 'absent'
        when 'service'
          it { should be_enabled } if item['parameters']['enable'] == true
          it { should be_running } if item['parameters']['ensure'] == 'running'
        when 'user', 'group'
          it { should exist } if item['parameters']['ensure'] == 'present'
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
