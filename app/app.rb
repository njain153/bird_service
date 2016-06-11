module BirdService
  class App < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers
    enable :sessions
    disable :show_exceptions, :dump_errors, :raise_errors

    error do
      view_obj = { errors: {} }
      if $!.kind_of?(BirdServiceException)
        http_status = $!.status_code
        view_obj[:description] = $!.description
        $!.errors.each { |k,v| view_obj[:errors][k] = (v.is_a?(Array) ? v : [v]) }
      else
        http_status = 500
        view_obj[:description] = "Unexpected server error"
      end
      error http_status, view_obj.to_json
    end

  end
end
