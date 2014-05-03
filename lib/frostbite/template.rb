module Frostbite
  class Template    
    require 'erb'
      
    @template = nil   
    @template_file = nil
    @elements = nil
    @controller = nil
      
    def initialize(file)
      @elements = Hash.new(0) 
      @template_file = file     
    end
    
    # Build HTML fragment results
    def build_fragment!(handler, name, data) 
      Logger.info "Building collection fragment for #{handler.capitalize} (#{name.upcase})..."
          
      collection = Array.new

      collection.push()
             
      case handler
        when 'zendesk'
          case name
            when 'open_tickets'
              data.each do |t|
                collection.push(t)
              end
            when 'solved_tickets'
              data.each do |t|
                collection.push(t)
              end
            when 'created_tickets'
              data.each do |t|
                collection.push(t)
              end
          end 
        else
          Logger.warn "Failed to find handler method for \"#{handler.capitalize}::#{name.upcase}\"."
      end
      
      return collection
    end   
  
    def build_erb_element!(name, data)
      @elements[name] = Array.new        
      @elements[name].push(data)
    end  
    
    def build_erb_element_single!(name,data)
      @elements[name] = data
    end

    def build_html!
      return(get_template(@template_file).result(@controller.get_erb_binding()))
    end
    
    def fields_generator
      @fields = @elements
    end

    # Helper to get object bindings
    def get_erb_binding
      binding
    end
    
    private     
    
      def get_template(file)
        Logger.debug "Loading template file \"#{File.basename(file)}\"..."
      
        begin
          @controller = self
          @controller.fields_generator()
          
          template = ERB.new(File.read(file))
          @template = template
        rescue Exception => e
          Logger.error "Failed to load customer template. (#{e.message})", e
        end
      
        return template
      end
     
  end
end
