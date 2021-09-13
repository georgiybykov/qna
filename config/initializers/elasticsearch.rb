# frozen_string_literal: true

path = Rails.root.join('config/elasticsearch.yml')

config = if File.exist?(path)
           YAML.load_file(path)[Rails.env]&.deep_symbolize_keys || {}
         else
           {
             host: 'http://localhost:9200/',
             transport_options: {
               request: {
                 timeout: 30
               }
             }
           }
         end

Elasticsearch::Model.client = Elasticsearch::Client.new(config)
