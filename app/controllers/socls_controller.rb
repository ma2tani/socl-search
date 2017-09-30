### SoundCloud Search Controller
### tracks page search
class SoclsController < ApplicationController
  def search
    if params[:keyword].present?
      require 'open-uri'
      require 'elasticsearch/transport'
      require 'multi_json'
      require 'faraday'
      require 'elasticsearch/api'
      require 'date'

      #include Elasticsearch::API

      # HEROKU_URL = 'https://herokusocl.herokuapp.com/api/0/'
      # ELASTICSEARCH_URL = 'http://localhost:9200/socl_index/track/'
      DEC_NUM = 1
      
      client = Elasticsearch::Client.new host: 'localhost:9200'
      client = Elasticsearch::Client.new urls: 'http://localhost:9200,http://localhost:9201'
      client = Elasticsearch::Client.new log: true
      client.transport.reload_connections!

      clientEs = EsSoclClient.new
      
      SEARCH_URL = 'https://herokusocl.herokuapp.com/api/0/'+params[:keyword]+'/tracks'
      res = open(SEARCH_URL)

      #uri = URI.parse('https://herokusocl.herokuapp.com/api/'+params[:keyword])
      #json = Net::HTTP.get(uri)
      code, message = res.status # res.status => ["200", "OK"]

      if code == '200'
        result = ActiveSupport::JSON.decode res.read
        docSize = result.size()
        id_number = docSize
        #result = JSON.parse(json)

        @socls = []
        result.each do |item|
          socl = Socl.new(
            item['name'].to_s,
            item['title'].to_s,
            item['uploadTime'].to_s,
            item['plays'].to_s,
            item['link'].to_s,
            item['postedTime'].to_s,
            item['image'].to_s,
          )
          @socls << socl

          artistName = socl.name
          imageUrl = socl.image
          # elasticsearch 登録
          
          clientEs.index  index: 'socl_index', type: 'track', id: "#{params[:keyword]}_#{id_number}", body: { name: socl.name, title: socl.title, uploadTime: socl.uploadTime, plays: socl.plays, link: socl.link, postedTime: socl.postedTime, image: socl.image }
          # dec id_number
          id_number -= DEC_NUM

          #p name: socl.name, title: socl.title, uploadTime: socl.uploadTime, plays: socl.plays, link: socl.link, postedTime: socl.postedTime, image: socl.image

        end

        clientEs.index  index: 'socl_index', type: 'history', id: "#{params[:keyword]}", body: { name: sartistName, searchTime: Date.today.to_time, searchName: params[:keyword], link: SEARCH_URL, total: docSize, image: imageUrl }

      else
        puts "OMG!! #{code} #{message}"
      end
    end
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