require 'rubygems'
require 'spork'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

Spork.prefork do
	RACK_ENV = 'test' unless defined?(RACK_ENV)

	require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
	require 'pathy'
	Object.pathy!

	TEST_HOST = Rack::Test::DEFAULT_HOST unless defined? TEST_HOST
	JSON_SECURITY_REGEX = %r{^\s*(while\s*\(\s*1\s*\)\s*\{\s*\})\s*} unless defined? JSON_SECURITY_REGEX

	require_relative '../app/controllers/birds'
	require_relative '../app/models/bird'
	require_relative '../app/helpers/exceptions/bird_service_exception'


	def app
		BirdService::App.tap { |app| }
	end
	
	# Populate the cache of MTIMES in the reloader, so subsequent reloads are super fast.
	# Padrino 0.11.4 doesn't populate the MTIMES for controllers, so the each_run below
	#  ends up loading the controllers over and over again post-fork.
	Padrino::Reloader.reload! if ENV['DRB']
end

Spork.each_run do
	Padrino::Reloader.reload! if ENV['DRB']
end


