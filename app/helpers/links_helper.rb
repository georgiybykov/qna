# frozen_string_literal: true

module LinksHelper
  GIST_REGEXP = %r{^(http|https)?://gist.github.com/?}.freeze

  def parse_url(url, name = nil)
    if GIST_REGEXP.match?(url)
      "<script src=\'#{url}.js\'></script>".html_safe # rubocop:disable Rails/OutputSafety:
      # content_tag("script src=\'#{url}.js\'")
      # tag("script src=\'#{url}.js\'")
      # tag(sanitize("script src=\'#{url}.js\'"))
      # tag.script(sanitize("#{url}.js", tags: %w[src]))
    else
      link_to(name || url, url, target: '_blank', rel: 'noopener')
    end
  end
end
