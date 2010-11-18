require 'open-uri'
require 'cgi'
require 'yaml'
require 'timeout'

module Autocomplete
  class Client
    attr_accessor :host, :port
    attr_accessor :logger

    # server uses sinatra with default port 4567
    DEFAULT_HOST = "localhost"
    DEFAULT_PORT = 4567

    def initialize(options = {})
      @host = options[:host] || DEFAULT_HOST
      @port = options[:port] || DEFAULT_PORT
      @logger = options[:logger]
    end

    def match(type, query, options = {})
      fetch_response(build_url(type, "match", query, options))
    end

    def find(type, query, options = {})
      fetch_response(build_url(type, "find", query, options))
    end

    def refresh(type)
      url = "http://#{@host}:#{@port}/#{type}/refresh"
      response = fetch_response(url)
      return response.is_a?(String) && response == "OK"
    end

  private

    def fetch_response(url)
      response = []
      begin
        Timeout::timeout(0.5) do
          open(url) do |content|
            response = YAML::load(content.read)
          end
        end
      rescue Timeout::Error => e
        @logger.error("Timeout: #{e}") if @logger
      rescue => e
        @logger.error("Error: #{e}") if @logger
      end
      response
    end

    def build_url(type, method, query, options)
      url = "http://#{@host}:#{@port}/#{type}/#{method}/#{CGI::escape(query)}.yml"
      unless options.empty?
        s = []
        options.each do |k,v|
          s << "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"
        end
        url = url + "?" + s.join("&")
      end
      url
    end
  end
end