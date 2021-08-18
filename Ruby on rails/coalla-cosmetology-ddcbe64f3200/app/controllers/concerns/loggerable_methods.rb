# frozen_string_literal: true

module LoggerableMethods
  extend ActiveSupport::Concern

  def logger_create(student, curr_user, desc)
    student.logs.create(editor_id: curr_user.id,
                        action_type: :created,
                        description: desc)
  end

  def logger_updated(student, curr_user, desc, attr = nil)
    if attr
      desc += "</br>"
      desc += attr.to_s
    end
    student.logs.create(editor_id: curr_user.id,
                        action_type: :updated,
                        description: desc)
  end

  def logger_merged(student, curr_user, desc)
    student.logs.create(editor_id: curr_user.id,
                        action_type: :merged,
                        description: desc)
  end

  def logger_delete(student, curr_user, desc)
    student.logs.create(editor_id: curr_user.id,
                        action_type: :deleted,
                        description: desc)
  end

  def student_link(student)
    ActionController::Base.helpers.link_to(student.display_name,
                                  edit_admin_student_path(student))
  end
end
