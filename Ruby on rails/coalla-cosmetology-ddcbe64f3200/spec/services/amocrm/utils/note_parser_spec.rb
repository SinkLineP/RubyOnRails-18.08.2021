require 'rails_helper'

RSpec.describe Amocrm::Utils::NoteParser do
  let(:note_text) { 'Кто: ДКР(\|/1\|/);,Откуда:Высокой страсти не имея Для звуков жизни не щадить,Не мог он ямба от хорея,Как мы ни бились, отличить(,тест: умел мотивировать( и поощрять, когда это было необходимо' }
  let(:field) { 'откуда' }
  let(:answer) { 'Высокой страсти не имея Для звуков жизни не щадить,Не мог он ямба от хорея,Как мы ни бились, отличить' }

  it 'parsing nil text' do
    result = described_class.parse(nil, field)
    expect(result).to be_nil
  end

  it 'parsing note text from field and to (' do
    result = described_class.parse(note_text, field)
    expect(result).to eq answer
  end

end