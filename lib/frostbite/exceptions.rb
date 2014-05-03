module Frostbite
  module Exceptions
    class FileNotFoundException < StandardError; end
    class InvalidHandlerException < StandardError; end
    class ZendeskHandlerAuthenticationException < StandardError; end
    class ReportGenerationFailureException < StandardError; end
  end
end