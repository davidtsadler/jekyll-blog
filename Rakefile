$:.unshift(File.dirname(__FILE__))
require 'yaml'
require 'lib/random'

task :default => [:'site:deploy:development']

namespace :site do
  namespace :deploy do
    desc 'Builds the site and deploys it locally using the built in server.'
    task :development => [:'env:development', :'build:development']

    desc 'Builds the site and deploys it to a remote server using rsync over ssh.'
    task :production => [:'env:production', :'build:production'] do
      config = @config['deployment'] || {}
      host = config['host'] || ask('Host?', nil, lambda { |answer| !answer.empty? }, 'You must enter a host')
      user = config['user'] || ask('User?', nil, lambda { |answer| !answer.empty? }, 'You must enter a user')
      port = config['port'] || ask('Port?', '22', lambda { |answer| !answer.empty? }, 'You must enter a port number')
      dir = config['directory'] || ask('Directory?', nil, lambda { |answer| !answer.empty? }, 'You must enter a directory')
      
      system("rsync -avz --delete --rsh='ssh -p#{port}' #{@config['destination']}/ #{user}@#{host}:#{dir}")
    end
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
  task :create => [:load_config, :clean, :create_directory] do
    (1..@config['num_test_posts']).each do |day|
      date, title, categories = TestPosts::Random.generate
      save_post(date, title, @config['author'], title, categories, @config['test_posts'])
    end
  end

  desc 'Deletes any test posts.'
  task :clean  => [:load_config] do
    FileUtils.rm_rf(@config['test_posts'])
  end

  desc 'Creates the required test posts directory if one does not exist.'
  task :create_directory => [:load_config] do
    create_directory(@config['test_posts'])
  end
end

namespace :post do
  desc 'Creates a new post based on user input'
  task :create => [:load_config, :create_directory] do
    date = Date.today.to_s
    title = nil
    author = @config['author']
    description = nil
    categories = nil

    loop do
      date = ask('Date?', date, lambda { |answer| !answer.empty? && answer =~ /^\d{4}-\d{2}-\d{2}$/ }, 'Date must be entered as YYYY-MM-DD')
      title = ask('Title?', title, lambda { |answer| !answer.empty? }, 'You must enter a title')
      author = ask('Author?', author)
      description = ask('Description?', description)
      categories = ask('Categories?', categories)
      break if agree('Ok to create this post?')
    end

    save_post(date, title, author, description, categories, @config['posts'])
  end

  desc 'Creates the required posts directory if one does not exist.'
  task :create_directory => [:load_config] do
    create_directory(@config['posts'])
  end
end

desc 'Loads the configuration file into an instance variable to be used by other tasks.'
task :load_config do
  @config = YAML::load_file('_config.yml')
  @config['posts'] = "#{@config['source']}/_posts"
  @config['test_posts'] = @config['posts'] + '/test'
end

def edit_config(name, value)
  config = File.read('_config.yml')
  regexp = Regexp.new('(^\s*' + name + '\s*:\s*)(\S+)(\s*)$')
  config.sub!(regexp,'\1'+value+'\3')
  File.open('_config.yml', 'w') {|f| f.write(config)}
end

def create_directory(dir)
  FileUtils.mkdir_p(dir) unless File.directory?(dir)
end

def save_post(date, title, author, description, categories, directory)
  # Ensure string is in the form of ["category one", "category two"]
  categories = "[#{categories.split(',').map { |c| '"' + c.strip + '"' }.join(',')}]"

  template = File.read("lib/templates/post.markdown")
  template.gsub!(/:title/, title)
  template.gsub!(/:author/, author)
  template.gsub!(/:description/, description)
  template.gsub!(/:categories/, categories)

  filename = "#{directory}/#{date}-#{parameterize(title)}.markdown"
  File.open(filename, 'w') { |f| f.write(template) }
end
  
def parameterize(string, sep = '-')
  string.downcase.gsub(/[^a-z0-9\-_]+/, sep)
end

def ask(prompt, default, validator = nil, message = nil)
  prompt << " |#{default}|" if default
  prompt << ' '
  answer = ''
  loop do
    print prompt
    answer = $stdin.gets.chomp
    answer = default if answer.empty? && default
    valid = validator ? validator.call(answer) : true
    puts(message) if message && !valid
    break if valid
  end
  answer
end

def agree(prompt)
  yn = ask(prompt, 'y', lambda { |yn| yn.downcase[0] == 'y' || yn.downcase[0] == 'n' }, "Enter y, n or yes, no")
  yn.downcase[0] == 'y'
end
