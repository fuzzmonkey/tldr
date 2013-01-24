require 'faraday'
require 'json'

module Tldr

  API_ENDPOINT = "https://api.tldr.io"

  class API

    def self.middleware &block
      @middleware = block
    end

    def initialize api_client_name, api_client_key
      @api_client_name = api_client_name
      @api_client_key = api_client_key
    end

    # GET /tldrs/latest/:number
    def latest articles=10
      make_request :get, "/tldrs/latest/#{articles}"
    end

    # GET /tldrs/search?url=:url
    def search url
      make_request :get, "/tldrs/search?url=#{url}"
    end

    # POST /tldrs/searchBatch
    # def batch_search urls
    #   make_request :post, "/tldrs/searchBatch", {"batch" => urls }
    # end

    def make_request method, url, body=nil
      rsp = connection.send(method, url) do |req|
        req.body = body.to_json if body
      end
      parsed_rsp = JSON.parse(rsp.body)
      return [] if parsed_rsp.is_a?(Hash) && parsed_rsp["message"] == "ResourceNotFound"
      parsed_rsp.is_a?(Array) ? parsed_rsp.map{|s| Summary.new(s) } : Summary.new(parsed_rsp)
    end

    def connection
      headers = {'api-client-name' => @api_client_name, 'api-client-key' => @api_client_key }
      @connection ||= Faraday.new(:url => API_ENDPOINT, :headers => headers, :builder => @middleware) 
    end

  end

end