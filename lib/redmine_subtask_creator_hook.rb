class RedmineSubtaskCreatorHook < Redmine::Hook::ViewListener
  include ApplicationHelper

  #Добавляем выбор пользователей в форму создания задачи
  render_on :view_issues_form_details_bottom, :partial => "users_for_subtasks" 

  #После сохранения новой задачи необходимо создать ее подзадачи, назначенные указанным пользователям
  #Для работы с новой и измененной задачей используются разные хуки. 
  def controller_issues_new_after_save(context={ })
    create_subtask_for_users(context[:issue], context[:params][:user_sbtsk_copylist]) if !context[:params][:user_sbtsk_copylist].nil?    
  end
  
  
  private
  
  #Процедура копирует указанную задачу в одну или несколько подзадач, на основании выбранных пользователей.
  def create_subtask_for_users(issue, list)
    list = list.reject{|e| e.empty?}
    list.each { |user_id|
      new_copy = Issue.new.copy_from(issue, :attachments => false) #копируем задачу без приложений
      new_copy.assigned_to_id = user_id.to_i
      new_copy.parent_issue_id= issue.id
#      new_copy.custom_field_values = issue.custom_field_values.inject({}) {|h,v| h[v.custom_field_id] = v.value; h}
      new_copy.save                   #сохраняем
    } 
  end

end
