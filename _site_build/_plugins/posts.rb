module Jekyll
  module ExcerptFilter
    def text_excerpt(text)
      text.split(@context.registers[:site].config['excerpt_tag']).first
    end
  end
end

Liquid::Template.register_filter(Jekyll::ExcerptFilter)
