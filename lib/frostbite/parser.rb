module Frostbite
  class Parser 
    require 'yaml'
         
    def self.process(template, customer_config)     
      begin
        Logger.info "Loading \"#{File.basename(customer_config)}\" configuration..."
        config = YAML.load_file(customer_config)
      rescue Exception => e
        Logger.error "Failed to load configuration file \"#{customer_config.to_s}\" (#{e.message})", e
      end
      
      config.each do |customer, values|
        values.each do |handler, options|
          collection = Hash.new(0)

          template.build_erb_element_single!('customer_name', customer.capitalize)
          
          case handler
            when 'zendesk'
              Logger.info "Starting #{customer.capitalize}'s Zendesk report generation..."
              zendesk = Frostbite::Handlers::Zendesk.new(options)
              
              options['collection'].each do |c| 
                collection[c[0]] = Array.new                 
                collection[c[0]].push(template.build_fragment!(handler, c[0], zendesk.build_collection!(c)))
                
                template.build_erb_element!(c[0], collection[c[0]])
              end
            when 'jira'
              jira = Frostbite::Handlers::Jira.new(options)
              options['collection'].each do |c| 
                template.build_erb_element_single!(c[0],jira.get_tasks(c))
              end

            else
              raise Frostbite::Exceptions::InvalidHandlerException, "Unable to find a handler that matches \"#{handler.capitalize}\""
          end
          
          # Write to HTML file
        end
        #Logger.info "About to build html, collection keys are: #{collection.keys}"
        generator = Frostbite::Generator.new(template.build_html!)
        #generator.write("archive/#{customer.to_s.chomp}-#{handler.to_s.chomp}.html")
        generator.write("archive/#{customer.to_s.chomp}.html")
      end        
    end     
  end
end