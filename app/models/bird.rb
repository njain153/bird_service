require 'singleton'
require 'mongo'

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
		database_name = 'bird_' + Padrino.env.to_s
		standard_db_timeout = 5
		@db = ::Mongo::MongoClient.new(host, port, :w => 1, :op_timeout => standard_db_timeout).db(database_name)
	end
end

class Bird

	RETRY_SLEEP = 2
	RETRY_COUNT = 3

	def self.collection
		Database.instance.db.collection("birds")
	end

	def save(id, body)
		document = {_id: id}.merge!(body)
		unless document['added']
			date = Time.new
			document[:added] = date.year.to_s  + "/" + date.month.to_s + "/" + date.day.to_s
		end
		begin
			with_retry {Bird.collection.insert(document)}
		rescue Mongo::OperationFailure => e
			raise ResourceExistsError, {bird: "with id #{id} already exists."} if Database.instance.db.get_last_error['code'] == 11000
		end
	end

	def find(bird_id)
		with_retry {Bird.collection.find_one({_id: bird_id})}
	end

	def remove(bird_id)
		result = with_retry {@result = Bird.collection.remove({_id: bird_id})}
		result["n"] == 1 ? true: false
	end

	def findAll
		result = with_retry {Bird.collection.find}
		result.each.reject{|b|  b['visible'] == false}.each.map{|b| b['_id']}
	end

	def with_retry
		retries = RETRY_COUNT
		begin
			yield
		rescue ::Mongo::ConnectionFailure, ::Mongo::OperationTimeout => ex
			retries = retries-1
			if retries >= 0
				Kernel.sleep RETRY_SLEEP
				retry
			end
			raise ex
		end
	end
end

