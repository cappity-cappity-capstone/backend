# Set the application directory
APP_DIR = File.expand_path(File.dirname(__FILE__))
TMP_DIR = File.join('/', 'tmp')
SOCKET_PATH = File.join(TMP_DIR, 'unicorn.sock')
PID_PATH = File.join(TMP_DIR, 'unicorn.pid')

working_directory APP_DIR
timeout 30

pid PID_PATH

if %w(staging production).include?(ENV['RACK_ENV'])
  listen SOCKET_PATH, backlog: 64
  preload_app true
  user 'nobody'
else
  listen 4567, backlog: 64
end
