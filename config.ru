require 'rubygems'
require 'bundler'

Bundler.require(:default)

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

libraries = Dir[File.expand_path('../lib/**/*.rb', __FILE__)]
libraries.each do |path_name|
  require path_name
end
