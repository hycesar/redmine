# This file is a part of Redmine ZenEdit (redmine_zenedit) plugin,
# editing enhancement plugin for Redmine
#
# Copyright (C) 2011-2024 RedmineUP
# http://www.redmineup.com/
#
# redmine_zenedit is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_zenedit is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_zenedit.  If not, see <http://www.gnu.org/licenses/>.

module RedmineZenedit
  module Hooks
    # <PRO>
    class ViewsLayoutsHook < Redmine::Hook::ViewListener
      render_on :view_layouts_base_html_head, partial: 'zenedit/additional_assets'

      def view_layouts_base_html_head(context={})
          javascript_include_tag(:zenedit, plugin: 'redmine_zenedit') +
            stylesheet_link_tag(:zenedit, plugin: 'redmine_zenedit')
      end
    end
    # </RPO>
  end
end
