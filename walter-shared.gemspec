Gem::Specification.new do |s|
  s.name        = 'walter-shared'
  s.version     = '1.0.1'
  s.date        = '2019-03-15'
  s.summary     = 'A loveable Logger.'
  s.description = 'A micro logging library that extends Ruby Logger.'
  s.email       = 'piersholt@gmail.com'
  s.homepage    = 'http://www.piersholt.com'
  s.authors     = ['Piers Holt']
  s.license     = 'All rights reserved.'
  s.post_install_message = 'Beause log actually..., is all around. ❤️'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '2.4.0'

  s.add_runtime_dependency 'rbczmq', '~> 1.7'

  s.files = ['lib/walter/shared.rb']

  s.files += ['lib/walter/shared/log_actually.rb']
  s.files += ['lib/walter/shared/yabber.rb']

  s.files += Dir['lib/walter/shared/log_actually/*.rb']
  s.files += Dir['lib/walter/shared/yabber/*.rb']

  s.files += Dir['lib/walter/shared/yabber/api/*.rb']
  s.files += Dir['lib/walter/shared/yabber/delegation/*.rb']
  s.files += Dir['lib/walter/shared/yabber/message/*.rb']
  s.files += Dir['lib/walter/shared/yabber/queue/*.rb']
end
