require 'rails_helper'

RSpec.describe Amocrm::Operations::DuplicateLead do
  before(:each) do
    mock_api
    find_lead_stub(item.amocrm_id)
    find_contacts_stub([item.contact_amocrm_id])
    find_contact_stub(item.contact_amocrm_id)
    leads_links_stub([item.amocrm_id])
    create(:group, id: item.group_id, title: item.group_title)
  end

  let(:lead_find_params) do
    ActiveSupport::JSON.decode(File.read('./spec/fixtures/leads/find.json'))
  end

  let (:group) do
    Group.find(item.group_id)
  end

  let (:item) do
    OpenStruct.new(amocrm_id: 44457232,
                   group_id: 552,
                   group_title: 'МлМС-ОД-1',
                   new_group_id: 553,
                   new_group_title: 'МлМС-ОД-2',
                   education_level_id: 4,
                   updated_at: DateTime.strptime('1510867065', '%s') - 1.hour,
                   contact_amocrm_id: 72595229)
  end

  let(:task) do
    described_class.new(item.amocrm_id, item.group_id)
  end

  describe '#perform' do
    it 'do nothing if amocrm_id is blank' do
      task = described_class.new('', item.group_id)
      expect(task.perform).to be_nil
    end

    it 'do nothing if group_id is blank' do
      task = described_class.new(item.amocrm_id, '')
      expect(task.perform).to be_nil
    end

    it 'raise Amocrm::UnduplicatableSubscription if lead not found' do
      fake_id = 14324676
      find_lead_stub(fake_id, false)
      task = described_class.new(fake_id, item.group_id)
      expect { task.perform }.to raise_error(Amocrm::UnduplicatableSubscription, 'Lead not found')
    end

    it 'raise Amocrm::UnduplicatableSubscription if group not found' do
      group.destroy
      expect { task.perform }.to raise_error(Amocrm::UnduplicatableSubscription, 'Group not found')
    end

    it 'do nothing for wrong pipeline' do
      body = lead_find_params
      body['response']['leads'].first['pipeline_id'] = 872490
      find_lead_stub(item.amocrm_id, true, body.to_json)
      expect(task.perform).to be_nil
    end

    it 'do nothing if price == 0' do
      body = lead_find_params
      body['response']['leads'].first['price'] = 0
      find_lead_stub(item.amocrm_id, true, body.to_json)
      expect(task.perform).to be_nil
    end

    it 'do nothing for fake group' do
      group.update(fake: true)
      expect(task.perform).to be_nil
    end

    ::AmocrmPipeline.sale_pipelines.each do |pipiline_id|
      context "if pipeline Id = #{pipiline_id}" do
        before(:each) do
          body = lead_find_params
          body['response']['leads'].first['pipeline_id'] = pipiline_id
          find_lead_stub(item.amocrm_id, true, body.to_json)
        end

        it 'create lead' do
          result = described_class.new(item.amocrm_id, item.group_id).perform
          expect(result.element_id).to eq(item.amocrm_id)
        end
      end
    end
  end
end