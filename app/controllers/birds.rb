require 'json'
require 'json-schema'
BirdService::App.controller  do

	before request_method: 'POST' do
		@req_body = request.body.read
		@payload = JSON.parse(@req_body) rescue nil
		raise InputValidationError, {body: 'must be valid JSON'} if @payload.nil?
		schema = JSON.parse(File.read('app/helpers/schemas/post-birds-request.json'))
		errors = JSON::Validator.fully_validate(schema, @payload, :errors_as_objects => true)
		unless errors.length == 0
			err_msg = errors[0][:message].split("in schema")[0].sub(/#\//,'/')
			raise InputValidationError, {payload: "not compliant: #{err_msg}"}
		end
	end

	get :index, map: "/birds/:bird_id" do
		bird = Bird.new
		response = bird.find(params[:bird_id])
		raise ResourceNotFoundError unless response
		@view_obj = response
		if  @view_obj['_id']
			@view_obj['id'] = @view_obj['_id']
			@view_obj.delete('_id')
		end
		status(200)
		render 'shared/index'
	end

	get :list, map: "/birds" do
		bird = Bird.new
		@view_obj = bird.findAll
		status(200)
		render 'shared/index'
	end

	post :create, map: "/birds/:bird_id" do
		raise InputValidationError, {added: "shold be in YYYY-MM-DD format"} if (@payload['added'] && @payload['added'] !~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/)
		bird = Bird.new
		bird.save(params[:bird_id], @payload)
		redirect URI.join("http://localhost:3000", url_for(:index, :bird_id => params[:bird_id])).to_s, 201
	end


	delete :delete, map: "/birds/:bird_id" do
		bird = Bird.new
		response = bird.remove(params[:bird_id])
		raise ResourceNotFoundError unless response
		status(200)
	end

end

