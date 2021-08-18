require 'rails_helper'

RSpec.describe Amo::LeadsController, :run_delayed_jobs, type: :controller do

  before(:each) { mock_api }

  let (:add_hook_params) { read_json('./spec/fixtures/leads/add_hook.json') }
  let (:update_hook_params) { read_json('./spec/fixtures/leads/update_hook.json') }

  let (:prepare_data) do
    leads_links_stub([item.amocrm_id])
    find_contacts_stub([item.contact_amocrm_id])
    create(:group, id: item.group_id, title: item.group_title)
    create(:student,
           amocrm_id: item.contact_amocrm_id,
           education_level_id: item.education_level_id)
    find_lead_stub(item.amocrm_id)
  end

  let (:group_subscription) do
    GroupSubscription.find_by(amocrm_id: item.amocrm_id)
  end

  let (:student) do
    Student.find_by(amocrm_id: item.contact_amocrm_id)
  end

  let (:group) do
    Group.find(item.group_id)
  end

  let (:new_group) do
    Group.find(item.new_group_id)
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


  describe 'POST create' do
    context 'if params is empty' do
      it "return 'no data processed'" do
        post :create, {}
        expect(response_json['result']).to eq('no data processed')
      end

      xit 'return no errors' do
        post :create, {}
        expect(response_json['errors']).to eq([])
      end
    end

    context 'if :leads params is empty' do
      it "return 'no data processed'" do
        post :create, { leads: [] }
        expect(response_json['result']).to eq('no data processed')
      end

      xit 'return no errors' do
        post :create, { leads: [] }
        expect(response_json['errors']).to eq([])
      end
    end

    context 'if leads[add] params is incorrect' do
      before(:each) do
        find_contacts_stub([item.contact_amocrm_id])
        find_lead_stub(item.amocrm_id)
        leads_links_stub([item.amocrm_id])
      end

      xit "don't create subscription for lead marked as removed" do
        params = add_hook_params
        params['leads']['add']['0']['custom_fields']['4'] = {
          'id' => '1772898',
          'name' => 'removed_from_sdo',
          'values' => {
            '0' => {
              'value' => '1'
            }
          }
        }
        post :create, params
        expect(response_json['errors']).to contain_exactly("Couldn't create or update record. Lead removed from SDO.")
      end

      xit "don't create subscription for lead with wrong group" do
        create(:group, id: 1)
        post :create, add_hook_params
        expect(response_json['errors']).to contain_exactly("Couldn't create or update record. Couldn't find Group with id=552")
      end

      xit "don't create subscription for not licked lead" do
        leads_links_stub([item.amocrm_id], false)
        create(:group, id: item.group_id)
        post :create, add_hook_params
        expect(response_json['errors']).to contain_exactly("Couldn't create or update record. Lead has no contacts")
      end

      xit "don't create subscription for lead without users" do
        create(:group, id: item.group_id)
        post :create, add_hook_params
        expect(response_json['errors']).to contain_exactly("Couldn't create or update record. Couldn't find Student with amocrm_id=72595229")
      end
    end

    context 'if leads[add] params is correct' do
      before(:each) do
        prepare_data
      end

      it "return 'ok'" do
        post :create, add_hook_params
        expect(response_json['result']).to eq('ok')
      end

      xit 'return no errors' do
        post :create, add_hook_params
        expect(response_json['errors']).to eq([])
      end

      it 'create subscription' do
        post :create, add_hook_params
        expect(group_subscription).to be_present
      end

      it 'create only one subscription for one user' do
        post :create, add_hook_params
        subscriptions_count = GroupSubscription
                                .joins(:student)
                                .where(users: { amocrm_id: item.contact_amocrm_id },
                                       amocrm_id: item.amocrm_id)
                                .count
        expect(subscriptions_count).to eq(1)
      end

      it 'create subscriptions for all users with amocrm_id' do
        create(:student, amocrm_id: item.contact_amocrm_id)
        post :create, add_hook_params
        students_ids = Student.where(amocrm_id: item.contact_amocrm_id).pluck(:id).sort
        data = GroupSubscription
                 .where(student_id: students_ids,
                        amocrm_id: item.amocrm_id)
                 .group(:student_id)
                 .order(:student_id)
                 .count
        expect(data).to contain_exactly(*(students_ids.map { |id| [id, 1] }))
      end

      it 'calculate payments' do
        create(:group_price,
               id: 1,
               group_id: item.group_id, amount: 2000,
               payments_text: '1000;1000')
        post :create, add_hook_params
        expect(group_subscription.payments.map(&:amount)).to contain_exactly(1000, 1000)
      end

      it 'generate course documents' do
        create(:course_document,
               education_level_id: item.education_level_id,
               course: Course.first)
        post :create, add_hook_params
        expect(group_subscription.subscription_documents).to be_present
      end

      %i(subscription_contract questionnaire).each do |document|
        it "generate #{document}" do
          post :create, add_hook_params
          expect(group_subscription.send(document)).to be_present
        end
      end

      %i(vacation_order change_group_order).each do |document|
        it "don't generate #{document}" do
          post :create, add_hook_params
          expect(group_subscription.send(document)).to be_blank
        end
      end
    end

    context 'if leads[update] params is correct' do
      before(:each) do
        prepare_data
        create(:group,
               id: item.new_group_id,
               title: item.new_group_title,
               begin_on: Date.current + 30.days,
               end_on: Date.current + 90.days)
      end

      context 'and subscription not exists' do
        it "return 'ok'" do
          post :create, update_hook_params
          expect(response_json['result']).to eq('ok')
        end

        it 'create subscription' do
          post :create, update_hook_params
          subscription = GroupSubscription.find_by(amocrm_id: item.amocrm_id)
          expect(subscription).to be_present
        end
      end

      context 'and subscription exists' do
        before(:each) do
          create(:group_price,
                 id: 1,
                 group_id: item.group_id,
                 amount: 2000,
                 payments_text: '1000;1000')
          create(:group_subscription,
                 id: 5,
                 student: student,
                 group: group,
                 amocrm_id: item.amocrm_id,
                 updated_at: item.updated_at)
        end

        it "don't update subscription if data outdated" do
          group_subscription.touch
          group_subscription.reload
          before_updated_at = group_subscription.updated_at
          post :create, update_hook_params
          group_subscription.reload
          expect(group_subscription.updated_at).to eq(before_updated_at)
        end

        it "don't update deleted subscription" do
          group_subscription.update_columns(deleted_at: Time.current)
          before_updated_at = group_subscription.updated_at
          post :create, update_hook_params
          group_subscription.reload
          expect(group_subscription.updated_at).to eq(before_updated_at)
        end

        it 'change group_id' do
          post :create, update_hook_params
          expect(group_subscription.group_id).to eq(new_group.id)
        end

        it "don't change begin_on" do
          begin_on_was = group_subscription.begin_on
          post :create, update_hook_params
          expect(group_subscription.begin_on).to eq(begin_on_was)
        end

        it "don't change end_on" do
          end_on_was = group_subscription.end_on
          post :create, update_hook_params
          expect(group_subscription.end_on).to eq(end_on_was)
        end

        it 'change amocrm_status_id' do
          post :create, update_hook_params
          expect(group_subscription.amocrm_status_id).to eq(AmocrmStatus.success.id)
        end

        it 'change discount_id' do
          create(:discount, id: 5)
          post :create, update_hook_params
          expect(group_subscription.discount_id).to eq(5)
        end

        it 'change education_form_id' do
          post :create, update_hook_params
          expect(group_subscription.education_form_id).to eq(2)
        end

        it 'change group_price_id' do
          create(:group_price, id: 7)
          post :create, update_hook_params
          expect(group_subscription.group_price_id).to eq(7)
        end

        it 'change amo_module_id' do
          create(:amo_module, id: 1)
          post :create, update_hook_params
          expect(group_subscription.amo_module_id).to eq(1)
        end

        it 'change responsible_name' do
          post :create, update_hook_params
          expect(group_subscription.responsible_name).to eq('Всеволод Бельченко')
        end

        it 'generates change_group_order for new group' do
          post :create, update_hook_params
          expect(group_subscription.change_group_order).to be_present
        end

        it 'change amocrm_tags' do
          post :create, update_hook_params
          expect(group_subscription.amocrm_tags).to contain_exactly('ИК')
        end

        notification_names = {
          'СКДИ' => 'skdi_notification',
          'СК' => 'sk_notification',
          'КЭ' => 'ke_notification',
          'KV' => 'ks_notification'
        }
        notification_names['{other tags}'] = ::Course.status_notification_name.default_value

        let(:update_hook_params_for_email_tests) do
          params = update_hook_params
          params['leads']['update']['0']['status_id'] = ::AmocrmStatus::SUCCESS.to_s
          params['leads']['update']['0']['old_status_id'] = '123456'
          params['leads']['update']['0']['price'] = 1000
          params
        end

        context 'and status_id changed' do
          notification_names.each do |tag, notification_name|
            it "don't send '#{notification_name}' notification" do
              create(:course, name: 'Test', short_name: tag, status_notification_name: notification_name)
              params = update_hook_params_for_email_tests
              params['leads']['update']['0']['tags']['1'] = { 'id' => 2, 'name' => tag }
              group_subscription.update!(amocrm_tags: [tag])
              expect(CosmetologyMailer).not_to receive(notification_name)
              post :create, params
            end

            it "don't send '#{notification_name}' notification for zero price" do
              params = update_hook_params_for_email_tests
              params['leads']['update']['0']['tags']['1'] = { 'id' => 2, 'name' => tag }
              params['leads']['update']['0']['price'] = ''
              group_subscription.update!(amocrm_tags: [tag])
              expect(CosmetologyMailer).not_to receive(notification_name)
              post :create, params
            end

            it "don't send '#{notification_name}' notification if subscription expired" do
              params = update_hook_params_for_email_tests
              params['leads']['update']['0']['tags']['1'] = { 'id' => 2, 'name' => tag }
              group_subscription.update!(end_on: Time.current - group_subscription.expire_period_for_course - 1.day)
              expect(CosmetologyMailer).not_to receive(notification_name)
              post :create, params
            end
          end
        end

        context 'and status_id is not changed, but tags changed' do
          notification_names.each do |tag, notification_name|
            it "send '#{notification_name}' notification" do
              create(:course, name: 'Test', short_name: tag, status_notification_name: notification_name)
              params = update_hook_params_for_email_tests
              params['leads']['update']['0']['tags']['1'] = { 'id' => 2, 'name' => tag }
              group_subscription.update_columns(amocrm_tags: [],
                                                amocrm_status_id: AmocrmStatus.success.id)
              expect(CosmetologyMailer).to receive(notification_name)
                                             .and_return(double('CosmetologyMailer', deliver!: true))
              post :create, params
            end

            it "don't send '#{notification_name}' notification for zero price" do
              params = update_hook_params_for_email_tests
              params['leads']['update']['0']['price'] = ''
              group_subscription.update_columns(amocrm_tags: [],
                                                amocrm_status_id: AmocrmStatus.success.id)
              expect(CosmetologyMailer).not_to receive(notification_name)
              post :create, params
            end

            it "don't send '#{notification_name}' notification if subscription expired" do
              create(:course, name: 'Test', short_name: tag, status_notification_name: notification_name)
              params = update_hook_params_for_email_tests
              params['leads']['update']['0']['tags']['1'] = { 'id' => 2, 'name' => tag }
              group_subscription.update!(end_on: Time.current - group_subscription.expire_period_for_course - 1.day)
              group_subscription.update_columns(amocrm_tags: [],
                                                amocrm_status_id: AmocrmStatus.success.id)
              expect(CosmetologyMailer).not_to receive(notification_name)
              post :create, params
            end
          end
        end

        context 'and contact changed' do
          before(:each) do
            group_subscription.update!(student: create(:student))
            group_subscription.update_columns(updated_at: item.updated_at)
          end

          it 'change student_id changed' do
            post :create, update_hook_params
            group_subscription.reload
            expect(group_subscription.student_id).to eq(student.id)
          end

          it "don't create subscriptions" do
            count_was = ::GroupSubscription.with_deleted.count
            post :create, update_hook_params
            expect(::GroupSubscription.with_deleted.count).to eq(count_was)
          end

        end
      end
    end
  end
end
