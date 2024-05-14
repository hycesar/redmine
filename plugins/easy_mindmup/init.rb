Redmine::Plugin.register :easy_mindmup do
  name 'Easy MindMup plugin'
  author 'Easy Software Ltd'
  url 'https://www.easysoftware.com'
  author_url 'https://www.easysoftware.com'
  description 'Mind map view based on MindMup'
  version '2.0'

  requires_redmine version_or_higher: '5.0'

  settings partial: nil, default: {}
end

require_relative 'after_init'

