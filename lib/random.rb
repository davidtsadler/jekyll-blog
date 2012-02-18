module TestPosts
  module Random
    APPLICATIONS = ['Apache 2', 'MySQL', 'Sqlite', 'Magento']

    DISTROS = ['Ubuntu', 'Fedora', 'Kubuntu', 'Mythbuntu', 'SUSE Linux', 'Debian']

    FRAMEWORKS = ['Ruby on Rails', 'CakePHP', 'Wordpress', 'Sinatra', 'Drupal']

    LANGUAGES = ['Actionscript', 'Ada', 'Assembly', 'C', 'C#', 'C++', 'Cobol', 'ColdFusion', 'D', 'Delphi', 'Erlang', 'Forth', 'Fortran', 'Haskell', 'Java', 'JavaScript', 'Lisp', 'Lua', 'OCaml', 'Objective C', 'PHP', 'Pascal', 'Perl', 'Python', 'Rexx', 'Ruby', 'SQL', 'Scala', 'Scheme', 'Shell', 'Smalltalk', 'Tcl', 'Visual Basic']

    TITLES = [
      [['Getting started with', 'A tutorial on', 'Why I like', "Why I don't like", 'Developing applications with'], LANGUAGES + FRAMEWORKS],
      [['Getting started with', 'How to install', 'How to upgrade'], DISTROS + APPLICATIONS + FRAMEWORKS],
      [['Developing a plugin for'], FRAMEWORKS]
    ]
  
    def self.generate
      topics, subjects = TITLES[rand(TITLES.size)]
      topic = topics[rand(topics.size)] 
      subject = subjects[rand(subjects.size)]
      [date, topic + ' ' + subject, subject]
    end

  private
    def self.date
      jdFrom = Date.today.prev_year.jd
      jdTo = Date.today.jd
      Date.jd(rand((jdTo + 1) - jdFrom) + jdFrom).strftime('%Y-%m-%d')
    end
  end
end
