lib_dir = File.join(File.dirname(__FILE__), 'lib', 'easy_wbs')

# Redmine patches
patch_path = File.join(lib_dir, '*_patch.rb')
Dir.glob(patch_path).each do |file|
  require file
end

require lib_dir
require File.join(lib_dir, 'hooks')

Redmine::MenuManager.map :project_menu do |menu|
  menu.push(:easy_wbs, { controller: 'easy_wbs', action: 'index'},
    param: :project_id,
    caption: :'easy_wbs.button_project_menu')
end

Redmine::AccessControl.map do |map|
  map.project_module :easy_wbs do |pmap|
    pmap.permission :view_easy_wbs, { easy_wbs: [:index] }, read: true
    # pmap.permission :edit_easy_wbs, { easy_wbs: [:create, :update, :destroy, :update_layout] }
  end
end
