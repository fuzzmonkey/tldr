require 'spec_helper'
require 'webmock/rspec'

describe Tldr::API do

  describe 'api methods' do

    before :all do
      @api = Tldr::API.new('foo','bar')
    end

    context 'latest n articles' do

      it 'should return the latest n articles' do
        stub_request(:get, "https://api.tldr.io/tldrs/latest/1").to_return(:body => load_response("latest_articles"), :status => 200)

        results = @api.latest 1

        results.size.should eq 1
        results.first.title.should eq "Drake, or 'make for data' (ETL)"
      end

    end

    context 'search' do

      it 'should return results for a single url' do
        stub_request(:get, "https://api.tldr.io/tldrs/search?url=http%3A%2F%2Fwww.bbc.co.uk%2Fnews%2Fhealth-21178718").to_return(:body => load_response("search"), :status => 200)

        result = @api.search 'http://www.bbc.co.uk/news/health-21178718'
        result.title.should eq "Antibiotic 'apocalypse' warning"
      end

      it 'should handle no results' do
        stub_request(:get, "https://api.tldr.io/tldrs/search?url=foo").to_return(:body => "{\"message\": \"ResourceNotFound\"}", :status => 200)

        result = @api.search 'foo'
        result.should be_empty
      end

    end

    # context 'batch search' do
    # 
    #   it 'should return results for a batch of urls' do
    #     results = @api.batch_search ['http://blog.codeable.io/2013/01/24/how-to-test-whether-your-idea-has-a-market.html']#['http://www.medicaldesignbriefs.com/component/content/article/15536','http://www.kapilkale.com/blog/gmails-second-major-problem']
    #     p results
    #   end
    # 
    #   it 'should handle no results' do
    #   end
    # 
    # end

  end

  describe 'net connections' do

    before :all do
      Tldr::API.middleware do |connection|
        connection.adapter = :em_http
      end
      @api = Tldr::API.new('foo','bar')
    end

    # Faraday defaults to net/http, so we've already covered for synchronous.
    it 'should work asynchronously (em-http)' do

      EM.run {
        stub_request(:get, "https://api.tldr.io/tldrs/latest/1").to_return(:body => load_response("latest_articles"), :status => 200)

        results = @api.latest 1
        results.size.should eq 1
        results.first.title.should eq "Drake, or 'make for data' (ETL)"
        EM.stop
      }
    end

  end

end