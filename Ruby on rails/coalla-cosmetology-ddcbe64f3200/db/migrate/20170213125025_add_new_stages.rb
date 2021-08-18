class AddNewStages < ActiveRecord::Migration
  def up
    system_statuses = [AmocrmStatus::SUCCESS, AmocrmStatus::FAIL]
    AmocrmStatus.where.not(amocrm_id: system_statuses).update_all(category: 'Воронка')
    AmocrmStatus.where(amocrm_id: system_statuses).update_all(category: 'Общие')
    new_sale_stages.each do |amocrm_id, name|
      AmocrmStatus.create!(title: name, amocrm_id: amocrm_id, category: 'Отдельная воронка')
    end
  end

  def down
    AmocrmStatus.where(amocrm_id: new_sale_stages.keys)
    AmocrmStatus.update_all(category: nil)
  end

  private

  def new_sale_stages
    {
        11990269 => 'Первичное обращение',
        11990272 => 'Повторный звонок',
        11990275 => 'Встреча',
        11990278 => 'Следующее касание'
    }
  end
end
