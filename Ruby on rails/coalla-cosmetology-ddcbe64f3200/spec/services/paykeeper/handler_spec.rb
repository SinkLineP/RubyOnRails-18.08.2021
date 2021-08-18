require 'rails_helper'
# TODO: vcr
RSpec.describe Paykeeper::Handler do
  let (:payment_with_order_id_params) do
    read_json('./spec/fixtures/paykeeper/payment_with_order_id.json')
  end

  let (:payment_with_wrong_order_id_params) do
    read_json('./spec/fixtures/paykeeper/payment_with_wrong_order_id.json')
  end

  let (:payment_with_amocrm_id_params) do
    read_json('./spec/fixtures/paykeeper/payment_with_amocrm_id.json')
  end

  describe '#process_payment!' do
    it 'always creates receipt' do
      expect { described_class.new({}).process_payment! }.to change(CashReceipt, :count).by(1)
    end

    it 'always enqueues print job' do
      expect { described_class.new({}).process_payment! }.to change(Delayed::Job, :count).by(1)
    end

    it 'return false if data not loaded' do
      expect(described_class.new({}).process_payment!).to eq(false)
    end

    it "return false if data is't correct" do
      params = payment_with_wrong_order_id_params
      params['key'] = '812c82af66fd5f590d622c3766d93884'
      expect(described_class.new(params).process_payment!).to eq(false)
    end

    context 'if order found' do
      before(:each) do
        group = create(:group, begin_on: Date.current + 30.days, end_on: Date.current + 90.days)
        create(:group_price,
               group_id: group.id,
               amount: 24316,
               payments_text: '23316;1000')
      end

      let(:create_order) {
        -> (email, cart = true) {
          student = create(:student, email: email)
          subscription = create(:group_subscription, group: Group.first, student: student, group_price: GroupPrice.first)
          order = Order.create!(id: payment_with_order_id_params['orderid'], user: student, cart: cart)
          OrderGroupSubscription.create!(group_subscription: subscription, order: order)
          order
        }
      }

      it "return false if data is't correct" do
        create_order.('test@test.com')
        expect(described_class.new(payment_with_order_id_params).process_payment!).to eq(false)
      end

      it 'creates education payment' do
        order = create_order.(payment_with_order_id_params['clientid'])
        described_class.new(payment_with_order_id_params).process_payment!
        expect(PaymentLog.where(appointment: :education, order: order.id)).to be_exists
      end

      it 'change subscription status' do
        create_order.(payment_with_order_id_params['clientid'])
        described_class.new(payment_with_order_id_params).process_payment!
        expect(GroupSubscription.first.amocrm_status_id).to eq(AmocrmStatus.success.id)
      end
    end

    context 'if order not found' do
      it 'creates education payment if group subscription found by amocrm_id' do
        student = create(:student, email: payment_with_amocrm_id_params['client_email'])
        group = create(:group, title: payment_with_amocrm_id_params['service_name'], begin_on: Date.current + 30.days, end_on: Date.current + 90.days)
        create(:group_subscription, student: student, group: group, amocrm_id: payment_with_amocrm_id_params['orderid'])
        described_class.new(payment_with_amocrm_id_params).process_payment!
        expect(PaymentLog.where(appointment: :education, amount: payment_with_amocrm_id_params['sum'].to_f, student_id: student.id, group_id: group.id)).to be_exists
      end

      it 'creates education payment if group subscription found by service_name' do
        student = create(:student, email: payment_with_wrong_order_id_params['client_email'])
        group = create(:group, title: payment_with_wrong_order_id_params['service_name'], begin_on: Date.current + 30.days, end_on: Date.current + 90.days)
        create(:group_subscription, student: student, group: group)
        described_class.new(payment_with_wrong_order_id_params).process_payment!
        expect(PaymentLog.where(appointment: :education, amount: payment_with_wrong_order_id_params['sum'].to_f, student_id: student.id, group_id: group.id)).to be_exists
      end

      it 'creates extraordinary payment if student found and group subscription not found' do
        student = create(:student, email: payment_with_wrong_order_id_params['client_email'])
        described_class.new(payment_with_wrong_order_id_params).process_payment!
        expect(PaymentLog.where(appointment: :extraordinary, amount: payment_with_wrong_order_id_params['sum'].to_f, student_id: student.id)).to be_exists
      end

      it 'sends notification about extraordinary payment if student found and group subscription not found' do
        create(:student, email: payment_with_wrong_order_id_params['client_email'])
        expect(CosmetologyMailer).to receive(:extraordinary_payment).and_return(double('CosmetologyMailer', deliver!: true))
        described_class.new(payment_with_wrong_order_id_params).process_payment!
      end

      it 'sends notification about failed payment if student not found' do
        create(:student, email: 'test@mail.ru')
        expect(CosmetologyMailer).to receive(:failed_payment).and_return(double('CosmetologyMailer', deliver!: true))
        described_class.new(payment_with_wrong_order_id_params).process_payment!
      end
    end
  end
end