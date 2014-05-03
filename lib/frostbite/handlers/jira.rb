module Frostbite
  module Handlers
    require 'frostbite/handler'
    require 'rest_client'
    require 'pp'
    
    class Jira < Handlers::Base        
      @options = nil
      @username = nil
      @password = nil
      @site = nil
      @protocol = nil
      @contextPath = nil
      @improvementsProject = nil
      
      def initialize(options) 

        @options = options
          
        begin
          configure(@options)
        rescue Exception => e
          Logger.error e.message, e
        end
      end
      
      # Build data collection for tickets
      def get_tasks(opt) 

        extra_opts = opt[1]

        s=@protocol + '://' + @site + '/' + @contextPath + '/search?jql=project=' + extra_opts['project_code'] + '&status=' + extra_opts['status']
        Logger.info "About to call JIRA service: #{s}"
        response = RestClient::Request.new(
                                  :method => :get,
                                  :url => @protocol + '://' + @site + '/' + @contextPath + '/search?jql=project=' + extra_opts['project_code'] + '&status=' + extra_opts['status'],
                                  :user => @username,
                                  :password => @password,
                                  :headers => { :accept => :json,
                                                :content_type => :json }
                    ).execute

        results = JSON.parse(response.to_str)


        tickets = Array.new 

        results.each do | jiraObject |

          if jiraObject[0] != 'issues'
            next
          end

          jiraObject[1].each do | jiraTicket |

          tickets.push(jiraTicket)
          end

        end

        return tickets

      end
      
      private
        def configure(options)            
          begin
            # Consider the use of :use_ssl and :ssl_verify_mode options if running locally 
            # for tests.

            @username = options['username']
            @password = options['password']
            @site = options['site']
            @protocol = options['protocol']
            @contextPath = options['contextPath']
            @improvementsProject = options['improvementsProject']


          rescue Exception => e
            Logger.error e.message, e
          end
        end


    end
  end
end
