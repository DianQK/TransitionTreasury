Pod::Spec.new do |s|
  s.name = 'TransitionTreasury'
  s.version = '2.2.1'
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.summary = 'Easier way to push your viewController.'
  s.homepage = 'https://github.com/DianQK/TransitionTreasury'
  s.screenshots  = 'https://raw.githubusercontent.com/DianQK/TransitionTreasury/master/transitiontreasury.png'
  s.social_media_url = 'http://transitiontreasury.com'
  s.authors = { 'DianQK' => 'xiaoqing@dianqk.org' }
  s.source = { :git => 'https://github.com/DianQK/TransitionTreasury.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = ['TransitionTreasury/*.{h,swift}','TransitionTreasury/*Transition/*.{h,swift}','TransitionTreasury/TransitionAnimation/*.swift']
  s.public_header_files = ["TransitionTreasury/TransitionTreasury.h"]

  s.requires_arc = true
end
