require 'rails_helper'

RSpec.describe Amo::ContactsController, :run_delayed_jobs, type: :controller do

  let (:add_hook_params) do
    read_json('./spec/fixtures/contacts/add_hook.json')
  end

  let (:update_hook_params) do
    read_json('./spec/fixtures/contacts/update_hook.json')
  end

  let (:delete_hook_params) do
    read_json('./spec/fixtures/contacts/delete_hook.json')
  end

  let (:item) do
    OpenStruct.new(amocrm_id: 72595229,
                   phone: '9104950985',
                   email: 'dyagileva-1992@mail.ru',
                   education_level_id: 4,
                   updated_at: DateTime.strptime('1510783931', '%s') - 1.hour, phones: ['9104950985'])
  end

  describe 'POST create' do
    context 'if params is empty' do
      it "return 'no data processed'" do
        post :create, {}
        expect(response_json['result']).to eq('no data processed')
      end
    end

    context 'if :contacts params is empty' do
      it "return 'no data processed'" do
        post :create, { contacts: [] }
        expect(response_json['result']).to eq('no data processed')
      end
    end

    context 'if contacts[add] email is already in use' do
      it "returns error" do
        student = create(:student, email: item.email)
        before_updated_at = student.updated_at
        post(:create, add_hook_params)
        student.reload
        expect(student.updated_at).to eq(before_updated_at)
      end
    end

    context 'if contacts[add] params is correct' do
      it "return 'ok'" do
        post :create, add_hook_params
        expect(response_json['result']).to eq('ok')
      end

      it 'create student' do
        post :create, add_hook_params
        expect(Student.find_by(amocrm_id: item.amocrm_id)).to be_present
      end

      it 'set source to amocrm' do
        post :create, add_hook_params
        expect(Student.find_by(amocrm_id: item.amocrm_id)).to be_amocrm
      end

      it 'create student with generated email' do
        params = add_hook_params
        params['contacts']['add']['0']['custom_fields'] = {}
        post :create, params
        student = Student.find_by(amocrm_id: item.amocrm_id)
        expect(student).to be_generated_email
      end
    end

    context 'if contacts[update] params is outdated' do
      it "don't update user" do
        before_update = create(:student, amocrm_id: item.amocrm_id)
        post :create, update_hook_params
        student = Student.find_by(amocrm_id: item.amocrm_id)
        expect(student.updated_at).to eq(before_update.updated_at)
      end
    end

    context 'if contacts[update] params is correct' do
      it "return 'ok'" do
        post :create, update_hook_params
        expect(response_json['result']).to eq('ok')
      end

      it 'create student' do
        post :create, update_hook_params
        expect(Student.find_by(amocrm_id: item.amocrm_id)).to be_present
      end

      it 'update emails' do
        create(:student,
               amocrm_id: item.amocrm_id,
               emails: %w(test@test.ru),
               updated_at: item.updated_at)
        post :create, update_hook_params
        student = Student.find_by(amocrm_id: item.amocrm_id)
        expect(student.emails).to contain_exactly('test@test.ru', item.email)
      end

      it "don't duplicate emails" do
        create(:student,
               amocrm_id: item.amocrm_id,
               emails: ['test@test.ru', item.email],
               updated_at: item.updated_at)
        post :create, update_hook_params
        student = Student.find_by(amocrm_id: item.amocrm_id)
        expect(student.emails).to contain_exactly('test@test.ru', item.email)
      end

      it "don't update emails if email is exist" do
        create(:student,
               amocrm_id: item.amocrm_id,
               email: item.email,
               updated_at: item.updated_at)
        post :create, update_hook_params
        student = Student.find_by(amocrm_id: item.amocrm_id)
        expect(student.emails).to be_blank
      end

      it 'update phones' do
        create(:student,
               amocrm_id: item.amocrm_id,
               phones: %w(9107112222),
               updated_at: item.updated_at)
        post :create, update_hook_params
        student = Student.find_by(amocrm_id: item.amocrm_id)
        expect(student.phones).to contain_exactly('9107112222', item.phone)
      end

      it "don't duplicate phones" do
        create(:student,
               amocrm_id: item.amocrm_id,
               phones: [item.phone],
               updated_at: item.updated_at)
        post :create, update_hook_params
        student = Student.find_by(amocrm_id: item.amocrm_id)
        expect(student.phones).to contain_exactly(item.phone)
      end

      {
        first_name: 'Екатерина',
        last_name: 'Макарова',
        middle_name: 'Игоревна',
        amo_created_at: DateTime.strptime('1487023896', '%s'),
        comagic_campaign: 'Поисковое продвижение'
      }.each do |field, value|
        it "update #{field}" do
          create(:student, amocrm_id: item.amocrm_id, updated_at: item.updated_at)
          post :create, update_hook_params
          student = Student.find_by(amocrm_id: item.amocrm_id)
          expect(student.send(field)).to eq(value)
        end
      end

      it 'update education_level_id' do
        create(:student, amocrm_id: item.amocrm_id, updated_at: item.updated_at)
        post :create, update_hook_params
        student = Student.find_by(amocrm_id: item.amocrm_id)
        expect(student.education_level_id).to eq(item.education_level_id)
      end
    end
  end

  describe 'POST delete' do
    context 'if params is empty' do
      it "return 'no data processed'" do
        post :delete, {}
        expect(response_json['result']).to eq('no data processed')
      end
    end

    context 'if :contacts params is empty' do
      it "return 'no data processed'" do
        post :delete, { contacts: [] }
        expect(response_json['result']).to eq('no data processed')
      end
    end

    context 'if contacts[add] params is correct' do
      let(:deleted_contact_amocrm_id) { 75914014 }

      before(:each) do
        create(:student, amocrm_id: deleted_contact_amocrm_id)
      end

      it "return 'ok'" do
        post :delete, delete_hook_params
        expect(response_json['result']).to eq('ok')
      end

      it "return 'ok'" do
        post :delete, delete_hook_params
        expect(response_json['result']).to eq('ok')
      end

      it 'set deleted_at' do
        post :delete, delete_hook_params
        student = Student.find_by(amocrm_id: 75914014)
        expect(student).to be_deleted
      end
    end
  end
end
