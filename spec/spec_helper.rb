$: << File.join(File.dirname(__FILE__), '..', 'lib')
require 'tldr'

RSpec.configure do |config|
  config.color_enabled = true
end

def load_response filename
  IO.read("spec/support/#{filename}_response.json")
end