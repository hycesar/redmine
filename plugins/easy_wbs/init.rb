Redmine::Plugin.register :easy_wbs do
  name 'Easy WBS plugin'
  author 'Easy Software Ltd'
  url 'https://www.easysoftware.com'
  author_url 'https://www.easysoftware.com'
  description 'new WBS tree hierarchy generator'
  version '2.0'

  requires_redmine_plugin :easy_mindmup, version_or_higher: '2.0'
end

require_relative 'after_init'

