root = File.dirname(__FILE__)
require File.join( root, 'index' )

run Rack::URLMap.new({
  "/"   => Index
})
