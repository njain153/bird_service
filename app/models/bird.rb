require 'singleton'

class Database

	include Singleton

	def db(opts = {})
		connect
		@db
	end

	def connect
		return if @db
		# Connection.new takes host, port
		port = ::Mongo::Connection::DEFAULT_PORT
		host = 'localhost'
		database_name = 'bird_development'
		standard_db_timeout = 5
		@db = ::Mongo::MongoClient.new(host, port, :w => 1, :op_timeout => standard_db_timeout).db(database_name)
	end
end

class Bird

	def save
		docment = {}
		collection.insert(document, {w: 1})
	end

	def find
	end

	def remove

	end

	self
	def collection
		Database.instance.db.collection("birds")
	end
end

