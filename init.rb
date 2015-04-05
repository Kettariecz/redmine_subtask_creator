require 'redmine'

require_dependency 'redmine_subtask_creator_hook'

unless Redmine::Plugin.registered_plugins.keys.include?(:redmine_subtask_creator)
	Redmine::Plugin.register :redmine_subtask_creator do
	  name 'Subtask Creator'
	  author 'Alexander Kulemin'
	  description 'Plugin can help you to create few subtasks when you create an first parent task - you only check users (thy will be assigned to subtasks) on create issues form.'
	  version '0.0.1'
	  

    project_module :redmine_subtask_creator do
      permission :create_subtask, :issues => :create_subtask_for_users
    end	  
	  
	end
end
