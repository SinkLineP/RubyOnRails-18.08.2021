module NotesHelper
  def note_text(note)
    formatters = {
      1 => ->(note) { note.text.html_safe },
      2 => ->(note) { note.text.html_safe },
      3 => ->(note) { note_status_changed_text(note) },
      4 => ->(note) { note.text.html_safe },
      5 => ->(note) { note.json_value('HTML').html_safe },
      6 => ->(note) { '[событие не поддерживается]' },
      7 => ->(note) { note_message_link(note) },
      8 => ->(note) { note_message_link(note) },
      9 => ->(note) { '[событие не поддерживается]' },
      10 => ->(note) { note_phone_call_text(note) },
      11 => ->(note) { note_phone_call_text(note) },
      12 => ->(note) { '[событие не поддерживается]' },
      13 => ->(note) { '[событие не поддерживается]' },
      102 => ->(note) { '[событие не поддерживается]' },
      103 => ->(note) { '[событие не поддерживается]' },
      15 => ->(note) { amo_note_message_link(note) },
      25 => ->(note) { note.text.html_safe }
    }
    formatters[note.note_type.to_i].call(note)
  end

  def note_message_link(note)
    link_to(note.json_value('subject') || 'empty subject', "https://cosmeticru.amocrm.ru/private/mxs.php?ID=#{note.json_value('mid')}", target: '_blank', class: 'a_under')
  end

  def amo_note_message_link(note)
    link_to(note.json_value('subject') || 'empty subject', "https://cosmeticru.amocrm.ru/mail/thread/#{note.json_value('thread_id')}", target: '_blank', class: 'a_under')
  end

  def note_phone_call_text(note)
    ("#{note.note_type_text} #{note.json_value('PHONE')} #{note_duration_text(note)} " +
      link_to('Прослушать', note.notable.amocrm_url, target: '_blank', class: 'a_under')).html_safe
  end

  def note_duration_text(note)
    duration = note.json_value('DURATION').to_i
    "#{duration / 60}:#{duration % 60}"
  end

  def note_status_changed_text(note)
    "#{note.json_value('TEXT').html_safe}. Новый этап: #{AmocrmStatus.find_by(amocrm_id: note.json_value('STATUS_NEW')).try(:title)}"
  end


end