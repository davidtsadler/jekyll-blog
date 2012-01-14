module Jekyll
  # Monkey patch so that both GenerateCategoryIndexes and CategoryFilter have access to this method.
  class Site
    # A very simple implementation.
    def parameterize(string, sep = '-')
      string.downcase.gsub(/[^a-z0-9\-_]+/, sep)
    end
  end

  class CategoryIndex < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['category'] = category

      title_prefix = site.config['category_title_prefix'] || 'Category: '
      self.data['title'] = "#{title_prefix}#{category}"

      description_prefix = site.config['category_meta_description_prefix'] || 'Category: '
      self.data['description'] = "#{description_prefix}#{category}"
    end
  end

  class GenerateCategoryIndexes < Generator
    safe true
    priority :low

    def generate(site)
      if site.config['generate_category_indexes'] && site.layouts.key?('category_index')
        dir = site.config['category_dir'] || 'categories'
        site.categories.keys.each do |category|
          write_category_index(site, File.join("/#{dir}", site.parameterize(category)), category)
        end
      end
    end

    def write_category_index(site, dir, category)
      index = CategoryIndex.new(site, site.source, dir, category)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.pages << index
    end
  end

  module CategoryFilter
    def category_links(categories)
      site = @context.registers[:site]
      directory = site.config['category_dir'] || 'categories'
      categories = categories.sort.map do |item|
        '<a href="/' + directory + '/' + site.parameterize(item) + '/" rel="category tag" target="_self" title="View all posted in ' + item +'">' + item + '</a>'
      end
      categories.join(', ')
    end
  end

end

Liquid::Template.register_filter(Jekyll::CategoryFilter)
