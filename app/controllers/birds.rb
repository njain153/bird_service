require 'json'
require 'json-schema'
BirdService::App.controller  do

	before request_method: 'POST' do
		req_body = request.body.read
		payload = JSON.parse(req_body)
		schema = JSON.parse(File.read('app/helpers/schemas/post-birds-request.json'))
		errors = JSON::Validator.fully_validate(schema, payload, :errors_as_objects => true)
		unless errors.length == 0
			err_msg = errors[0][:message].split("in schema")[0].sub(/#\//,'/')
			raise InputValidationError, {payload: "not compliant: #{err_msg}"}
		end
	end

	get :index, map: "/v1.0/birds/:bird_id" do
		puts "called with id :#{params[:bird_id]}"

		status(201)
		render 'shared/index'
	end

	post :create, map: "/v1.0/birds/" do
		status(200)
		render 'shared/index'
	end


	get :delete, map: "/v1.0/birds/:bird_id" do
		puts "called with id :#{params[:bird_id]}"
		status(200)
		render 'shared/index'
	end

end

