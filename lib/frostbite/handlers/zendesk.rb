module Frostbite
  module Handlers
    require 'frostbite/handler'
    require 'zendesk_api'
    
    class Zendesk < Handlers::Base        
      @client = nil
      @options = nil
      
      def initialize(options) 
        @options = options
          
        begin
          configure(@options)
        rescue Exception => e
          Logger.error e.message, e
        end
      end
      
      # Build data collection for tickets
      def build_collection!(opt) 
        collection = []
        extra_opts = opt[1]
        zd_query = ''       
                   
        case opt[0]
          when 'created_tickets'
            Logger.info "Building Zendesk #{opt[0].upcase} collection..."

            if !extra_opts['date_start'].empty?
              zd_query << "created>#{extra_opts['date_start']} "
            end
            
            if !extra_opts['date_end'].empty?
              zd_query << "created<#{extra_opts['date_end']} "
            end
            
            collection = @client.search(
              query: "type:ticket group:#{@options['organization']} #{zd_query}"
            )
            Logger.info "Building Zendesk #{opt[0].upcase} query is: #{zd_query}..."
          when 'sev1_tickets'
            Logger.info "Building Zendesk #{opt[0].upcase} collection..."

            if !extra_opts['date_start'].empty?
              zd_query << "created>#{extra_opts['date_start']} "
            end
            
            if !extra_opts['date_end'].empty?
              zd_query << "created<#{extra_opts['date_end']} "
            end

            zd_query << "severity:Sev1"
            
            collection = @client.search(
              query: "type:ticket group:#{@options['organization']} #{zd_query}"
            )
          when 'open_tickets'
            Logger.info "Building Zendesk #{opt[0].upcase} collection..."
            
            if !extra_opts['date_start'].empty?
              zd_query << "created>#{extra_opts['date_start']} "
            end
            
            if !extra_opts['date_end'].empty?
              zd_query << "created<#{extra_opts['date_end']} "
            end
            
            collection = @client.search(
              query: "type:ticket group:#{@options['organization']} status:open #{zd_query}"
            )
          when 'solved_tickets'
            Logger.info "Building Zendesk #{opt[0].upcase} collection..."
            
            if !extra_opts['date_start'].empty?
              zd_query << "solved>#{extra_opts['date_start']} "
            end
            
            if !extra_opts['date_end'].empty?
              zd_query << "solved<#{extra_opts['date_end']} "
            end
            
            collection = @client.search(
              query: "type:ticket group:#{@options['organization']} status:solved status:closed #{zd_query}"
            )
        else
          Logger.warn "Not yet implemented for #{opt[0].upcase} collection method."
        end
        
        return collection
      end
      
      private
        def configure(options)            
          begin
            # Set up Zendesk client
            @client = ZendeskAPI::Client.new do |config|
              config.url = options['url']
              config.username = options['auth_email']
              config.token = options['auth_token']
            end
          rescue Exception => e
            Logger.error e.message, e
          end
        end
    end
  end
end
