Gem::Specification.new do |s|
  s.name        = 'timert'
  s.version     = '1.0.1'
  s.date        = '2013-07-30'
  s.summary     = "Timert is a simple time tracking tool for the console."
  s.description = "Timert is a simple time tracking tool for the console. "\
    "If necessary you can specify a time you want the timer "\
    "to start or to stop. The tool provides also summary reports "\
    "for a given day, week or month"
  s.authors     = ["Gosia Kwidzinska"]
  s.email       = 'g.kwidzinska@gmail.com'
  s.files       = Dir.glob("{bin,lib}/**/*")
  s.test_files  = Dir.glob("{spec}/**/*")
  s.executables = ['timert']
  s.homepage    =
    'http://github.com/mkwidzinska/timert'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'timecop'
  s.add_runtime_dependency 'colorize'
end
