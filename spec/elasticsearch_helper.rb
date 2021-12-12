# frozen_string_literal: true

require 'elasticsearch/extensions/test/cluster'

RSpec.configure do |config|
  # CI env is always `true` for GitHub Actions.
  if ENV['CI'].blank?
    creds = Rails.application.credentials

    # @see https://github.com/elastic/elasticsearch-ruby/blob/b3cfdcbde678c2704c0a557a163782b9e027d144/elasticsearch-extensions/lib/elasticsearch/extensions/test/cluster.rb#L78
    cluster = Elasticsearch::Extensions::Test::Cluster::Cluster
                .new(
                  cluster_name: creds.dig(:elastic_test_cluster, :name)&.chomp || 'elastic-test-cluster',
                  network_host: creds.dig(:elastic_test_cluster, :network_host) || 'localhost',
                  number_of_nodes: creds.dig(:elastic_test_cluster, :nodes)&.to_i || 1,
                  port: creds.dig(:elastic_test_cluster, :port)&.to_i || 9250,
                  timeout: creds.dig(:elastic_test_cluster, :timeout)&.to_i || 120,
                  command: creds.dig(:elastic_test_cluster, :command) || '/usr/share/elasticsearch/bin/elasticsearch'
                )

    # Start an in-memory cluster for Elasticsearch as needed.
    config.before :all do # rubocop:disable RSpec/BeforeAfterAll
      cluster.start unless cluster.running?
    end

    # Stop elasticsearch cluster after test suits.
    at_exit do
      cluster.stop if cluster.running?
    end
  end

  # (!) NOTE: It does not make sense to create indicies here inside before-hook, because
  # we have to create/refresh them during specs execution after objects will be created.

  # Delete indexes for all elastic searchable models to ensure clean state between tests.
  config.after :each, :elasticsearch do
    ActiveRecord::Base.descendants.each do |model|
      next unless model.respond_to?(:__elasticsearch__)

      begin
        model.__elasticsearch__.delete_index!
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        # This kills 'Index does not exist' errors being written to console.
      rescue StandardError => e
        warn "There was an error removing the elasticsearch index for #{model.name}: #{e.inspect}"
      end
    end
  end
end
