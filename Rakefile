require 'yaml'

task :default => ['server']

desc 'Loads the configuration file into an instance variable to be used by other tasks.'
task :load_config do
  @config = YAML::load_file('_config.yml')
  @config['posts'] = "#{@config['source']}/_posts"
end

desc 'Runs the server.'
task :server => [:clean] do
  system 'bundle exec jekyll --server --auto'
end

desc 'Creates several test posts.'
task :posts => [:load_config, :clean_posts, :create_posts_directory] do
  year = Time.now.year
  (1..20).each do |day|
    save_post(Time.new(year, 1, day), "Dummy post #{day}")
  end
end

desc 'Creates the required posts directory if one does not exist.'
task :create_posts_directory => [:load_config] do
  Dir.mkdir(@config['posts']) unless File.directory?(@config['posts'])
end

desc 'Deletes any generated files.'
task :clean  => [:load_config] do
  FileUtils.rm_rf(@config['destination'])
end

desc 'Deletes any test posts.'
task :clean_posts  => [:load_config] do
  FileUtils.rm_rf(@config['posts'])
end

def save_post(date, title)
  template = File.read("templates/post.markdown")
  template.gsub!(/:title/, title)

  filename = "#{@config['source']}/_posts/#{date.strftime('%Y-%m-%d')}-#{parameterize(title)}.markdown"
  File.open(filename, 'w') { |f| f.write(template) }
end
  
def parameterize(string, sep = '-')
  string.downcase.gsub(/[^a-z0-9\-_]+/, sep)
end
