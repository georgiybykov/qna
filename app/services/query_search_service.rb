# frozen_string_literal: true

class QuerySearchService
  AVAILABLE_SCOPES = %w[Question Answer Comment User].freeze

  # @param search [Search]
  #
  # @return [Array, String]
  def call(search:)
    return string_error(search) unless search.valid?

    # ThinkingSphinx.search(
    #   ThinkingSphinx::Query.escape(search.query),
    #   classes: [search_klass(search.scope)]
    # ).to_a
  end

  private

  def string_error(search)
    return 'Something went wrong!' unless search.errors[:query].any?

    search.errors.full_messages_for(:query).first
  end

  def search_klass(scope)
    return unless AVAILABLE_SCOPES.include?(scope)

    scope.classify.constantize
  end
end
