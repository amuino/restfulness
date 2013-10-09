module Restfulness

  # 
  # The Restulness::Application is the starting point. It'll deal with 
  # defining the initial configuration, and handle incoming requests
  # from rack. 
  #
  # Build your own Restfulness applications by inheriting from this class:
  #
  #   class MyApp < Restfulness::Application
  #
  #     routes do
  #       scope 'api' do
  #         add 'journey', JourneyResource
  #         add 'journeys', JourneyCollectionResource
  #       end
  #     end
  #
  #   end
  #
  class Application


    def router
      self.class.router
    end

  
    def call(request)

    end


    class << self

      attr_accessor :router

      def routes(opts = {}, &block)
        self.router = Router.new(opts, &block)
      end

    end

  end

end
