require 'vcr'
require 'webmock'

VCR.configure do |vcr|
  vcr.allow_http_connections_when_no_cassette = false
  vcr.hook_into :webmock
  vcr.cassette_library_dir = File.join(File.dirname(__FILE__), '..', 'vcr')
  vcr.configure_rspec_metadata!
end
