module PopupTexts
  def popup_title
    working_time? ? 'Спасибо!' : 'Спасибо, что обратились к нам!'
  end

  def popup_text
    working_time? ? 'Мы обязательно свяжемся с вами.' : 'Институт работает с 9:00 до 21:00. С вами свяжутся в рабочее время.'
  end

  def working_time?
    9 <= Time.current.hour && Time.current.hour < 21
  end
end