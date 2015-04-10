module Cappy
  CLOUD_CLIENT_HOST = ENV['CLOUD_CLIENT_HOST'] || 'http://cappitycappitycapstone.com'
  CLOUD_CLIENT_UUID = ENV['CLOUD_CLIENT_UUID'] || 'development'

  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
