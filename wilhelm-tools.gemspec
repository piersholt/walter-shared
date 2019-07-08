Gem::Specification.new do |s|
  s.name        = 'wilhelm-tools'
  s.version     = '1.0.0'
  s.date        = '2019-03-15'
  s.summary     = 'A loveable Logger.'
  s.description = 'A micro logging library that extends Ruby Logger.'
  s.email       = 'piersholt@gmail.com'
  s.homepage    = 'http://www.piersholt.com'
  s.authors     = ['Piers Holt']
  s.license     = 'MIT'
  s.post_install_message = 'Beause log actually..., is all around. ❤️'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '2.4.0'

  s.bindir = 'bin'
  s.executables << 'subscribe'

  s.add_runtime_dependency 'rbczmq', '~> 1.7'

  s.files = ['lib/wilhelm/tools.rb']

  s.files += ['lib/wilhelm/tools/manageable_threads.rb']
  s.files += ['lib/wilhelm/tools/printable.rb']
  s.files += ['lib/wilhelm/tools/log_actually.rb']
  s.files += ['lib/wilhelm/tools/yabber.rb']

  s.files += Dir['lib/wilhelm/tools/log_actually/*.rb']
  s.files += Dir['lib/wilhelm/tools/yabber/*.rb']

  s.files += Dir['lib/wilhelm/tools/yabber/api/controller/*.rb']
  s.files += Dir['lib/wilhelm/tools/yabber/api/*.rb']
  s.files += Dir['lib/wilhelm/tools/yabber/delegation/*.rb']
  s.files += Dir['lib/wilhelm/tools/yabber/message/serialized/*.rb']
  s.files += Dir['lib/wilhelm/tools/yabber/message/*.rb']
  s.files += Dir['lib/wilhelm/tools/yabber/queue/*.rb']
end
