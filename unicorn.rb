# Set the application directory
APP_DIR = File.expand_path(File.dirname(__FILE__))
APP_PORT = (ENV['APP_PORT'] || 4567).to_i
PID_PATH = File.join(Dir.tmpdir, 'unicorn.pid')

timeout 30
working_directory APP_DIR
pid PID_PATH
listen APP_PORT, backlog: 64
