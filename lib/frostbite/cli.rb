require 'optparse'
require 'ostruct'

module Frostbite
  class Cli 
       
    @customer_config = nil
    @customer_template = nil
    @verbose_logging = false
         
    def self.run(args) 
      parse_args(args)
             
      begin              
        Logger.info "Starting Frostbite reporting engine..."
        Parser.process(Template.new(@customer_template), @customer_config)
      rescue Exception => e
        Logger.fatal "Report engine has crashed -- #{e.message}", e
        exit(1)
      end
    end
    
    private
    
      def self.parse_args(args)
        options = OpenStruct.new
        reopts = nil 
        
        OptionParser.new do |opts|
          opts.banner = "Usage: frostbite [OPTIONS]"
          opts.separator ""
          opts.separator "Specific options:"            
          
          opts.on("-c", "--customer FILE", "Customer configuration file to use for report") do |c|
            options.customer_config = c
          end
          
          opts.on("-t", "--template FILE", "Customer template file to use for report") do |t|
            options.customer_template = t
          end
          
          opts.separator ""
          opts.separator "Common options:"
          
          opts.on_tail("-v", "--verbose", "Run verbosely") do |v|
            options.verbose = v
          end
          
          opts.on_tail("-h", "--help", "This menu") do
            puts opts
            exit(0)
          end
          
          opts.on_tail("--version", "Show version") do
            puts "Frostbite Reporting Engine (#{Version::VERSION})"
            puts "#{Version::AUTHOR} (#{Version::AUTHOR_EMAIL})"
            exit(0)
          end
          
          reopts = opts
        end.parse!(args)
        
        # Validate customer presence
        if options.customer_config.nil?
          puts reopts
          raise ArgumentError, "You must specify a customer configuration file."
        end
        
        # Template been specified?
        if options.customer_template.nil?
          puts reopts
          raise ArgumentError, "You must specify a customer template file."            
        end
        
        # Make sure template exists
        if !File.exists?(options.customer_template)
          raise Exceptions::FileNotFoundException, "Couldn't locate the specified template file."
          puts reopts
        end
        
        @customer_config = options.customer_config
        @customer_template = options.customer_template
        @verbose_logging = options.verbose
      end
         
  end
end