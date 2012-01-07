require 'sanitize'

module Jekyll
  module PostFilter
    def truncate(html, num_characters = 1000, indicator = ' [...]')
      '<p>' << Sanitize.clean(html).slice(Regexp.new(".{1,#{num_characters}}( |$)")).chomp(' ') << indicator << '</p>'
    end

    def chomp_url(url, str = 'index.html')
      url.chomp(str)
    end
  end
end

Liquid::Template.register_filter(Jekyll::PostFilter)
