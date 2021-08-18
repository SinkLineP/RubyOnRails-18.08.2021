# frozen_string_literal: true

# Контроллер раздела "Объединение контактов"
# @see app/views/admin/contacts_merges
module Admin
  class ContactsMergesController < AdminController
    include LoggerableMethods

    authorize_resource

    def new
      @contacts_merge = ContactsMerge.new
    end

    def create
      @contacts_merge = ContactsMerge.new(params.require(:contact).permit!)
      unless @contacts_merge.save
        render :new
        return
      end
      logger_merged(@contacts_merge.main_student, current_user,
                    "Основной пользователь (id: #{@contacts_merge.main_student.id}): " + student_link(@contacts_merge.main_student).to_s + "</br>" +
                    "Вторичный пользователь (id: #{@contacts_merge.other_student.id}): " + student_link(@contacts_merge.other_student).to_s)
      redirect_to edit_admin_student_path(@contacts_merge.main_student_id)
    end
  end
end
