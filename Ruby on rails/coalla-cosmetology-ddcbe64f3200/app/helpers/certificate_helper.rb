module CertificateHelper

  def names_array(student, case_symbol)
    names = [student.last_name, student.first_name, student.middle_name].reject(&:blank?)
    if names.length == 3
      last_name, first_name, middle_name = names
      gender = Petrovich(middlename: middle_name).gender
      Petrovich(lastname: last_name,
                firstname: first_name,
                middlename: middle_name,
                gender: gender).to(case_symbol).to_s.split("\s")
    else
      names
    end
  end

  def program_volume(volume)
    "#{volume} #{program_volume_text(volume)}"
  end

  def program_volume_text(volume)
    Russian.p(volume, 'академический час', 'академических часа', 'академических часов')
  end

  def education_time_text(date_start, date_end)
    start_date, end_date = Russian.strftime(date_start, '%d %B %Y'), Russian.strftime(date_end, '%d %B %Y')
    start_date_array, end_date_array = start_date.split, end_date.split
    "c «#{start_date_array[0]}» #{start_date_array[1]} #{start_date_array[2]} года по «#{end_date_array[0]}» #{end_date_array[1]} #{end_date_array[2]} года"
  end

  def block_name(block_name)
    block_name.match(/[а-яА-Я][[а-яА-Я],\s,\d,\W]*\z/).to_s.strip
  end

end