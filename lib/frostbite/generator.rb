module Frostbite
  class Generator
    require 'fileutils'
      
    @html = nil
      
    def initialize(html)
      @html = html
    end
    
    def write(file)
      if !File.exist?(file)
        begin
          FileUtils.touch(file)
        rescue Exception => e
          raise Frostbite::Exceptions::FileNotFoundException, "Could not find file (#{file.to_s})"
        end          
      end
      
      begin
        # TODO: Create date stamp/customer directory structure 
        # under archive instead of dumping file to the root archive dir.
        if File.open(file, 'w') { |file| file.write(@html) }
          Logger.info "Successfully wrote HTML report to file (#{file})"
        else
          raise Frostbite::Exceptions::ReportGenerationFailureException
        end
      rescue Exception => e
        Logger.error "Failed to write HTML out to file", e
      end
    end        
  end
end