class AddAddNewPipelines < ActiveRecord::Migration
  def up
    amocrm_data_items.each do |amocrm_data|
      pipeline = AmocrmPipeline.create!(title: amocrm_data['title'], amocrm_id: amocrm_data['id'])
      amocrm_data['statuses'].each do |status_item|
        amocrm_status = AmocrmStatus.find_or_initialize_by(amocrm_id: status_item['id'])
        amocrm_status.assign_attributes(title: status_item['title'], amocrm_pipeline_id: pipeline.id, status_action: status_item[:status_action])
        amocrm_status.save!
      end
    end

    AmocrmPipeline.update_all(shop_id: nil)
    AmocrmPipeline.where(amocrm_id: 1349100).update_all(shop_id: Shop.cosmetic.id)
    AmocrmPipeline.where(amocrm_id: 1355847).update_all(shop_id: Shop.barbershop.id)
  end

  def down
    amocrm_data_items.each do |amocrm_data|
      pipeline = AmocrmPipeline.find_by(amocrm_id: amocrm_data['id'])
      pipeline.destroy! if pipeline
    end

    AmocrmPipeline.update_all(shop_id: nil)
    AmocrmPipeline.where(amocrm_id: 279892).update_all(shop_id: Shop.cosmetic.id)
    AmocrmPipeline.where(amocrm_id: 1019854).update_all(shop_id: Shop.barbershop.id)
  end

  private

  def amocrm_data_items
    [
      {
        'id' => 1349100,
        'title' => 'Первичная воронка Косметология',
        'statuses' => [
          { 'id' => 21650958, 'title' => 'Лид получен', status_action: :primary_treatment },
          { 'id' => 21650961, 'title' => 'Квалифицирован клиент' },
          { 'id' => 21651168, 'title' => 'Предложение отправлено' },
          { 'id' => 21650964, 'title' => 'Возражение отработано 1' },
          { 'id' => 21651171, 'title' => 'Возражение отработано 2' },
          { 'id' => 21651174, 'title' => 'Сделано специальное преложение' },
          { 'id' => 21651177, 'title' => 'Получена догоовренность о встрече', status_action: :meeting },
          { 'id' => 21651180, 'title' => 'Встреча подтверждена' },
          { 'id' => 21651183, 'title' => 'Встреча проведена' },
          { 'id' => 21651186, 'title' => 'Дожим 1: специальное предложение' },
          { 'id' => 21651189, 'title' => 'Дожим 2 и более' },
          { 'id' => 21651192, 'title' => 'Получена договоренность о финальной встрече' },
          { 'id' => 21651195, 'title' => 'Финальная встреча подтверждена' },
          { 'id' => 21651198, 'title' => 'Финальная встреча проведена' },
          { 'id' => 21651201, 'title' => 'Оплата определена' }
        ]
      },
      {
        'id' => 1355847,
        'title' => 'Воронка Продаж Парикмахеры',
        'statuses' => [
          { 'id' => 21710913, 'title' => 'Лид получен', status_action: :primary_treatment },
          { 'id' => 21711111, 'title' => 'Квалифицирован клиент' },
          { 'id' => 21711114, 'title' => 'Предложение отправлено' },
          { 'id' => 21711117, 'title' => 'Возражение отработано 1' },
          { 'id' => 21711120, 'title' => 'Возражение отработано 2' },
          { 'id' => 21711123, 'title' => 'Сделано специальное предложение' },
          { 'id' => 21711126, 'title' => 'Получена договоренность о встрече', status_action: :meeting },
          { 'id' => 21711129, 'title' => 'Встреча подтверждена' },
          { 'id' => 21711132, 'title' => 'Встреча проведена' },
          { 'id' => 21711135, 'title' => 'Дожим 1 - сделано специальное предложение' },
          { 'id' => 21711138, 'title' => 'Дожим 2 и более' },
          { 'id' => 21711141, 'title' => 'Получена договоренность о финальной встрече' },
          { 'id' => 21711144, 'title' => 'Финальная встреча подтверждена' },
          { 'id' => 21711147, 'title' => 'Финальная встреча проведена' },
          { 'id' => 21710916, 'title' => 'Оплата определена' }
        ]
      }
    ]
  end
end
