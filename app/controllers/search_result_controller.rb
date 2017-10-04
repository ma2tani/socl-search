### SoundCloud Search Result Controller
### tracks page search result
class SearchResultController < ApplicationController
    require 'open-uri'
    require 'elasticsearch/transport'
    require 'multi_json'
    require 'faraday'
    require 'elasticsearch/api'
    require 'date'
    require 'hashie'

    def init
        # if params[:keyword].present?
            client = Elasticsearch::Client.new host: 'localhost:9200'
            client = Elasticsearch::Client.new urls: 'http://localhost:9200,http://localhost:9201'
            client = Elasticsearch::Client.new log: true
            client.transport.reload_connections!
        
            clientEs = EsSoclClient.new
            if params[:keyword] == ""
                res = clientEs.search  index: 'socl_history', type: 'history', pretty: true, body: { query: { match_all: {} } }
            else
                res = clientEs.search  index: 'socl_history', type: 'history', pretty: true, body: { query: { simple_query_string: {  fields: ['_all'], query: params[:keyword], default_operator: 'and' } } }
            end
        
            mash = Hashie::Mash.new JSON.parse(res)
        
            @histories = []
            (mash.hits.hits).each do |item|
            history = History.new(
                item._source.name,
                item._source.searchName,
                item._source.searchTime,
                item._source.searchUrl,
                item._source.total,
                item._source.image,
            )
            @histories << history

            p history.name

            end
        # end
    end

    def result
        # if params[:keyword].present?
      
          #include Elasticsearch::API
      
          # HEROKU_URL = 'https://herokusocl.herokuapp.com/api/0/'
          # ELASTICSEARCH_URL = 'http://localhost:9200/socl_index/track/'
      
          client = Elasticsearch::Client.new host: 'localhost:9200'
          client = Elasticsearch::Client.new urls: 'http://localhost:9200,http://localhost:9201'
          client = Elasticsearch::Client.new log: true
          client.transport.reload_connections!
      
          clientEs = EsSoclClient.new
          if params[:keyword] == ""
            res = clientEs.search  index: 'socl_index', type: 'track', pretty: true, body: { query: { match_all: {} } }
          else
            res = clientEs.search  index: 'socl_index', type: 'track', pretty: true, body: { query: { simple_query_string: {  fields: ['_all'], query: params[:keyword], default_operator: 'and' } } }
          end
      
          mash = Hashie::Mash.new JSON.parse(res)
      
            @results = []
            (mash.hits.hits).each do |item|
                result = Socl.new(
                item._source.name,
                item._source.title,
                item._source.uploadTime,
                item._source.plays,
                item._source.link,
                item._source.postedTime,
                item._source.image,
                )
                @results << result
        
            end
         # else
          #  puts "OMG!! #{code} #{message}"
        #  end
        # end
    end
end

class EsSoclClient
    include Elasticsearch::API
  
    CONNECTION = ::Faraday::Connection.new url: 'http://localhost:9200'
  
    def perform_request(method, path, params, body)
      puts "--> #{method.upcase} #{path} #{params} #{body}"
  
      CONNECTION.run_request \
        method.downcase.to_sym,
        path,
        ( body ? MultiJson.dump(body): nil ),
        {'Content-Type' => 'application/json'}
    end
end