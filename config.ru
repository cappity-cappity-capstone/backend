constants = Cappy::Controllers.constants.map(&Cappy::Controllers.method(:const_get))
controllers = constants.select { |const| const.is_a?(Class) && (const < Sinatra::Base) }
map('/api') {
  use Rack::Cors do
    allow do
      origins '*'
      resource '*', :headers => :any, :methods => [:get, :post, :put, :delete, :options]
    end
  end

  run Rack::Cascade.new(controllers)
}

