class CreateAmocrmPipelines < ActiveRecord::Migration
  def up
    create_table :amocrm_pipelines do |t|
      t.text :title, null: false
      t.text :amocrm_id, null: false
      t.references :shop, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_reference :amocrm_statuses, :amocrm_pipeline
    add_foreign_key :amocrm_statuses, :amocrm_pipelines

    amocrm_data.each do |item|
      pipeline = AmocrmPipeline.create!(title: item['title'], amocrm_id: item['id'], shop_id: item['shop_id'])
      item['statuses'].each do |status_item|
        amocrm_status = AmocrmStatus.find_or_initialize_by(amocrm_id: status_item['id'])
        amocrm_status.assign_attributes(title: status_item['title'], amocrm_pipeline_id: pipeline.id)
        amocrm_status.save!
      end
    end

    remove_column :amocrm_statuses, :category
  end

  def down
    add_column :amocrm_statuses, :category, :text
    remove_reference :amocrm_statuses, :amocrm_pipeline
    drop_table :amocrm_pipelines
  end

  def amocrm_data
    [
      { 'id' => 279892,
        'shop_id' => Shop.cosmetic.id,
        'title' => 'Отдельная воронка',
        'statuses' => [
          { 'id' => 11990269, 'title' => 'Первичное обращение' },
          { 'id' => 11990272, 'title' => 'Следующее касание' },
          { 'id' => 11990275, 'title' => 'Встреча' },
          { 'id' => 11990278, 'title' => 'Планирование оплаты' },
          { 'id' => 14558649, 'title' => 'Условный отказ' },
          { 'id' => 15678654, 'title' => 'Дубль' }
        ] },
      { 'id' => 15591,
        'title' => 'Воронка',
        'statuses' => [
          { 'id' => 8391787, 'title' => 'Первичное обращение' },
          { 'id' => 8391790, 'title' => 'Может быть купять' },
          { 'id' => 8391793, 'title' => 'Теплые' },
          { 'id' => 9007842, 'title' => 'Агенты' },
          { 'id' => 11937384, 'title' => 'Встречи' }
        ] },
      { 'id' => 589968,
        'title' => 'Воронка Допродаж',
        'statuses' => [
          { 'id' => 14787777, 'title' => 'Получить фидбэк' },
          { 'id' => 14787780, 'title' => 'Выбор курса' },
          { 'id' => 14787783, 'title' => 'Встреча' },
          { 'id' => 17366091, 'title' => 'Планирование оплаты' },
          { 'id' => 17366094, 'title' => 'Условный отказ' }
        ] },
      { 'id' => 872490,
        'title' => 'Нулевая воронка',
        'statuses' => [
          { 'id' => 17394444, 'title' => 'Первичный контакт' },
        ] },
      { 'id' => 1019854,
        'shop_id' => Shop.barbershop.id,
        'title' => 'Парикмахеры',
        'statuses' => [
          { 'id' => 18661498, 'title' => 'Первичный контакт' },
          { 'id' => 18661501, 'title' => 'Следующее касание' },
          { 'id' => 18661504, 'title' => 'Встреча' },
          { 'id' => 18661513, 'title' => 'Планирование оплаты' },
          { 'id' => 18661516, 'title' => 'Условный отказ' },
        ]
      }]
  end
end
