# frozen_string_literal: true

require 'elasticsearch/extensions/test/cluster'

RSpec.configure do |config|
  # @see https://github.com/elastic/elasticsearch-ruby/blob/b3cfdcbde678c2704c0a557a163782b9e027d144/elasticsearch-extensions/lib/elasticsearch/extensions/test/cluster.rb#L78
  cluster = Elasticsearch::Extensions::Test::Cluster::Cluster
              .new(
                cluster_name: ENV.fetch('TEST_CLUSTER_NAME', 'elastic-test-cluster').chomp,
                network_host: ENV.fetch('TEST_CLUSTER_NETWORK_HOST', 'localhost'),
                number_of_nodes: ENV.fetch('TEST_CLUSTER_NODES', 1).to_i,
                port: ENV.fetch('TEST_CLUSTER_PORT', 9250).to_i,
                timeout: ENV.fetch('TEST_CLUSTER_TIMEOUT', 120).to_i,
                command: ENV.fetch('TEST_CLUSTER_COMMAND', '/usr/share/elasticsearch/bin/elasticsearch')
              )

  # Start an in-memory cluster for Elasticsearch as needed
  config.before :all do # rubocop:disable RSpec/BeforeAfterAll
    cluster.start unless cluster.running?
  end

  # Stop elasticsearch cluster after test suits
  at_exit do
    cluster.stop if cluster.running?
  end

  # (!) NOTE: It does not make sense to create indicies here inside before-hook, because
  # we have to create/refresh them during specs execution after objects will be created.

  # Delete indexes for all elastic searchable models to ensure clean state between tests
  config.after :each, :elasticsearch do
    ActiveRecord::Base.descendants.each do |model|
      next unless model.respond_to?(:__elasticsearch__)

      begin
        model.__elasticsearch__.delete_index!
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        # This kills 'Index does not exist' errors being written to console
      rescue StandardError => e
        warn "There was an error removing the elasticsearch index for #{model.name}: #{e.inspect}"
      end
    end
  end
end
