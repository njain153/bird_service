class BirdServiceException < Exception

	attr_reader :errors

	def initialize(errors={})
		super(description)
		@errors = errors
	end

	def description; end
	def status_code; end

	def build_view_object
		view_obj = {
			description: self.description,
			errors: {},
		}
		self.errors.each { |k,v| view_obj[:errors][k] = [v].flatten }
		view_obj
	end
end


class ResourceNotFoundError < BirdServiceException
	def description
		"Resource not found"
	end
	def status_code
		404
	end
end


class ResourceExistsError < BirdServiceException
	def description
		"Resource Already Exists"
	end
	def status_code
		403
	end
end


class InputValidationError < BirdServiceException
	def description
		"Input Validation Error"
	end
	def status_code
		400
	end
end