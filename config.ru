constants = Cappy::Controllers.constants.map(&Cappy::Controllers.method(:const_get))
controllers = constants.select { |const| const.is_a?(Class) && (const < Sinatra::Base) }
run Rack::Cascade.new(controllers)

