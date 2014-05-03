require 'securerandom'

module Frostbite
  module Logger
    extend self

    def error(message, e=nil)
      output << formatted_message(message, "ERROR")
      self.backtrace e
      write
    end
    
    def fatal(message, e=nil)
      output << formatted_message(message, "FATAL")
      self.backtrace e 
      write
    end
    
    def info(message, e=nil)
      output << formatted_message(message, "INFO") 
      self.backtrace e
      write
    end
    
    def warn(message, e=nil)
      output << formatted_message(message, "WARN")
      self.backtrace e
      write
    end
    
    def debug(message, e=nil)
      output << formatted_message(message, "DEBUG")
      self.backtrace e
      write
    end
    
    def backtrace(e)
      if !e.nil?
        e.backtrace.each { |l| self.error l }
      end
    end
    
    def write
      #File.open(filename, "w") { |f| f << output.join("\n") }
      puts output.join("\n")
      @output = []
    end
    
    private
    
      def formatted_message(message, message_type)
        "#{Time.now} | #{message_type}: #{message}"
      end
      
      def uuid_me?
        SecureRandom.uuid
      end
      
      def output
        @output ||= []
      end

  end
end