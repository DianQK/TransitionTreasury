Pod::Spec.new do |s|
  s.name = 'TransitionTreasury'
  s.version = '3.0.2'
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.summary = 'Easier way to push your viewController.'
  s.homepage = 'https://github.com/DianQK/TransitionTreasury'
  s.screenshots  = 'https://raw.githubusercontent.com/DianQK/TransitionTreasury/master/transitiontreasury.png'
  s.social_media_url = 'http://transitiontreasury.com'
  s.authors = { 'DianQK' => 'xiaoqing@dianqk.org' }
  s.source = { :git => 'https://github.com/DianQK/TransitionTreasury.git', :tag => s.version }
  s.default_subspec = "Core"
  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.subspec "Core" do |ss|
    ss.source_files = ['TransitionTreasury/*.swift','TransitionTreasury/*Transition/*.swift']
  end

  s.subspec "Animations" do |ss|
    ss.source_files = "TransitionTreasury/TransitionAnimation/*.swift"
    ss.dependency "TransitionTreasury/Core"
  end
end
