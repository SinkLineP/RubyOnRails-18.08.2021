RSpec.shared_examples 'all attributes' do |attributes|
  attributes ||= []

  subject { create(test_model_name) }

  it 'be valid with all attributes' do
    expect(subject).to be_valid
  end

  return if attributes.blank?

  context 'be invalid when' do
    attributes.each do |attribute|
      it "#{attribute} is empty" do
        item = build(test_model_name, attribute => nil)
        expect(item).not_to be_valid
      end
    end
  end
end