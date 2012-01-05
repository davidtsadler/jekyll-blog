require 'sanitize'

module Jekyll
  module TruncateFilter
    def truncate(html, num_characters = 1000, indicator = ' [...]')
      '<p>' << Sanitize.clean(html).slice(Regexp.new(".{1,#{num_characters}}( |$)")).chomp(' ') << indicator << '</p>'
    end
  end
end

Liquid::Template.register_filter(Jekyll::TruncateFilter)
