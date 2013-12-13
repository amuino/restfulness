module Restfulness

  module Dispatchers

    class Rack < Dispatcher

      def call(env)
        # Make sure we understand the request
        request = prepare_request(env)

        # Prepare a suitable response
        response = Response.new(request)
        response.run

        [response.status, response.headers, [response.payload || ""]]
      end

      protected

      def prepare_request(env)
        rack_req = ::Rack::Request.new(env)

        request = Request.new(app)

        request.uri        = rack_req.url
        request.action     = parse_action(rack_req.request_method)
        request.body       = rack_req.body
        request.headers    = prepare_headers(env)

        # Just in case something else got to body first
        request.body.rewind if request.body.is_a?(StringIO)

        # Useful info
        request.remote_ip  = rack_req.ip
        request.user_agent = rack_req.user_agent

        # Sometimes rack removes content type from headers
        request.headers[:content_type] ||= rack_req.content_type

        request
      end

      def parse_action(action)
        case action
        when 'DELETE', 'GET', 'HEAD', 'POST', 'PUT', 'PATCH', 'OPTIONS'
          action.downcase.to_sym
        else
          raise HTTPException.new(501)
        end
      end

      def prepare_headers(env)
        res = {}
        env.each do |k,v|
          next unless k =~ /^HTTP_/
          res[k.sub(/^HTTP_/, '').downcase.gsub(/-/, '_').to_sym] = v
        end
        res
      end

    end

  end

end
