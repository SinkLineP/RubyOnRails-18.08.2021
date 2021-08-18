class ChangeEducationFormForAllSubscriptions < ActiveRecord::Migration
  def up
    add_column :education_forms, :online, :boolean, null: false, default: false

    EducationForm.where(short_title: 'ОД').update_all(online: true)

    {
        142 => 'Успешно реализовано',
        143 => 'Закрыто и не реализовано'
    }.each do |amocrm_id, title|
      AmocrmStatus.find_or_create_by!(amocrm_id: amocrm_id, title: title)
    end

    GroupSubscription.where(education_form_id: nil).update_all(education_form_id: EducationForm.online.try(:id))
    GroupSubscription.where(sale_stage_id: nil).update_all(sale_stage_id: AmocrmStatus.success.try(:id))
  end

  def down
    remove_column :education_forms, :online
  end
end
