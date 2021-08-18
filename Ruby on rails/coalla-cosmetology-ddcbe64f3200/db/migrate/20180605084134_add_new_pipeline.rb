class AddNewPipeline < ActiveRecord::Migration
  def up
    pipeline = AmocrmPipeline.create!(title: amocrm_data['title'], amocrm_id: amocrm_data['id'])
    amocrm_data['statuses'].each do |status_item|
      amocrm_status = AmocrmStatus.find_or_initialize_by(amocrm_id: status_item['id'])
      amocrm_status.assign_attributes(title: status_item['title'], amocrm_pipeline_id: pipeline.id, status_action: status_item[:status_action])
      amocrm_status.save!
    end
  end

  def down
    pipeline = AmocrmPipeline.find_by(amocrm_id: amocrm_data['id'])
    pipeline.destroy! if pipeline
  end

  private

  def amocrm_data
    {
      'id' => 1173379,
      'title' => 'Модули',
      'statuses' => [
        { 'id' => 19975210, 'title' => 'Первичный контакт', status_action: :primary_treatment },
        { 'id' => 19975213, 'title' => 'Переговоры' },
        { 'id' => 19975216, 'title' => 'Принимают решение' }
      ]
    }
  end
end
