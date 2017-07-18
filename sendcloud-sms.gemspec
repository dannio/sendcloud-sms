Gem::Specification.new do |s|
  s.name        = 'sendcloud-sms'
  s.version     = '0.0.3'
  s.date        = '2016-07-13'
  s.summary     = 'An fork to unofficial gem sendcloud-sms. https://github.com/heckpsi-lab/sendcloud-sms'
  s.description = 'An fork to unofficial gem sendcloud-sms. https://github.com/heckpsi-lab/sendcloud-sms'
  s.authors     = ['dannio']
  s.email       = 'dcwongy@gmail.com'
  s.files       = ['lib/sendcloud-sms.rb']
  s.require_paths = ['lib']
  s.homepage    = 'https://github.com/dannio/sendcloud-sms'
  s.license     = 'MIT'

  s.add_runtime_dependency 'rest-client', '>= 1.8.0'
end
