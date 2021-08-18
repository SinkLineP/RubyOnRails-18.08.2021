# == Schema Information
#
# Table name: notes
#
#  id           :integer          not null, primary key
#  notable_id   :integer
#  notable_type :string
#  noted_at     :datetime
#  amocrm_id    :text
#  note_type    :integer
#  text         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_notes_on_notable_type_and_notable_id  (notable_type,notable_id)
#

class Note < ActiveRecord::Base
  SMS = 103
  COMMENT = 4
  MAIL_WITH_FILE = 8

  NOTES_DESCRIPTIONS = {
    1 => 'Сделка создана',
    2 => 'Контакт создан',
    3 => 'Статус сделки изменен',
    COMMENT => 'Обычное примечание',
    5 => 'Файл',
    6 => 'Звонок приходящий от iPhone-приложений',
    7 => 'Письмо',
    MAIL_WITH_FILE => 'Письмо с файлом',
    9 => 'Не используется',
    10 => 'Входящий звонок',
    11 => 'Исходящий звонок',
    12 => 'Компания создана',
    13 => 'Результат по задаче',
    102 => 'Входящее смс',
    SMS => 'Исходящее смс',
    15 => 'Письмо'
  }

  belongs_to :notable, polymorphic: true

  validates :text, :note_type, :noted_at, presence: true

  # "письмо с файлом" дополнительно генерируется для событий с типом "письмо"
  # не нужно показывать это событие отдельно
  default_scope { where.not(note_type: MAIL_WITH_FILE) }

  def note_type_text
    NOTES_DESCRIPTIONS[note_type.to_i] || ''
  end

  def json_value(field_name)
    @json ||= ActiveSupport::JSON.decode(text)
    @json.try(:[], field_name)
  end
end
