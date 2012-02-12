$:.unshift(File.dirname(__FILE__))
require 'yaml'
require 'lib/random'

task :default => [:'site:deploy:development']

namespace :site do
  namespace :deploy do
    desc 'Builds the site and deploys it locally using the built in server.'
    task :development => [:'env:development', :'build:development']

    desc 'Builds the site and deploys it to a remote server.'
    task :production => [:'env:production', :'build:production']
  end

  namespace :build do
    desc 'Builds the site and runs the local built in server.'
    task :development => [:clean] do
      system 'bundle exec jekyll --server --auto'
    end

    desc 'Builds the site so that it can be deployed.'
    task :production => [:'test_posts:clean', :clean] do
      system 'bundle exec jekyll'
    end
  end

  namespace :env do
    desc 'Sets the configuration for development mode.'
    task :development do
      edit_config 'production', 'false'
    end

    desc 'Sets the configuration for production mode.'
    task :production do
      edit_config 'production', 'true'
    end
  end 

  desc 'Deletes any generated files.'
  task :clean  => [:load_config] do
    FileUtils.rm_rf(@config['destination'])
  end
end

namespace :test_posts do
  desc 'Creates several test posts.'
  task :create => [:clean, :create_directory] do
    (1..@config['num_test_posts']).each do |day|
      date, title, category = TestPosts::Random.generate
      save_post(date, title, "Testing", "A test post", category, true)
    end
  end

  desc 'Deletes any test posts.'
  task :clean  => [:load_config] do
    FileUtils.rm_rf(@config['posts'] + '/test')
  end

  desc 'Creates the required posts directory if one does not exist.'
  task :create_directory => [:load_config] do
    dir = @config['posts'] + '/test'
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
  end

private
  def save_post(date, title, author, description, categories, test = false)
    template = File.read("lib/templates/post.markdown")
    template.gsub!(/:title/, title)
    template.gsub!(/:author/, author)
    template.gsub!(/:description/, description)
    template.gsub!(/:categories/, categories)

    filename = "#{@config['source']}/_posts"
    filename << '/test' if test
    filename << "/#{date.strftime('%Y-%m-%d')}-#{parameterize(title)}.markdown"
    File.open(filename, 'w') { |f| f.write(template) }
  end
    
  def parameterize(string, sep = '-')
    string.downcase.gsub(/[^a-z0-9\-_]+/, sep)
  end
end

desc 'Loads the configuration file into an instance variable to be used by other tasks.'
task :load_config do
  @config = YAML::load_file('_config.yml')
  @config['posts'] = "#{@config['source']}/_posts"
end

def edit_config(name, value)
  config = File.read('_config.yml')
  regexp = Regexp.new('(^\s*' + name + '\s*:\s*)(\S+)(\s*)$')
  config.sub!(regexp,'\1'+value+'\3')
  File.open('_config.yml', 'w') {|f| f.write(config)}
end
