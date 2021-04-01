# frozen_string_literal: true

module LinksHelper
  GIST_REGEXP = %r{^(http|https)?://gist.github.com/?}.freeze

  def parse_url(url, name = nil)
    if GIST_REGEXP.match?(url)
      "<script src=\'#{url}.js\'></script>".html_safe # rubocop:disable Rails/OutputSafety
    else
      link_to(name || url, url, target: '_blank', rel: 'noopener')
    end
  end
end
