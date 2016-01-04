Pod::Spec.new do |s|
  s.name = 'EECellSwipeGestureRecognizer'
  s.version = '0.4.1'
  s.license = 'MIT'
  s.summary = 'Clean and easy way to implement swipe actions to UITableViewCell'
  s.homepage = 'https://github.com/enricenrich/EECellSwipeGestureRecognizer'
  s.social_media_url = 'https://twitter.com/enricenrich'
  s.authors = { 'Enric Enrich' => 'enric@enric.co' }
  s.source = { :git => 'https://github.com/enricenrich/EECellSwipeGestureRecognizer.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/*.swift'

  s.requires_arc = true
end