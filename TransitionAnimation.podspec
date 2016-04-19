Pod::Spec.new do |s|
  s.name = 'TransitionAnimation'
  s.version = '3.0.4'
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.summary = 'Transition Animation with TransitionTreasury'
  s.homepage = 'https://github.com/DianQK/TransitionTreasury'
  s.screenshots  = 'https://raw.githubusercontent.com/DianQK/TransitionTreasury/master/transitiontreasury.png'
  s.social_media_url = 'http://transitiontreasury.com'
  s.authors = { 'DianQK' => 'xiaoqing@dianqk.org' }
  s.source = { :git => 'https://github.com/DianQK/TransitionTreasury.git', :tag => s.version }
  s.source_files = ['TransitionAnimation/*.swift']
  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.dependency 'TransitionTreasury', '~> 3.0'
end
