#encoding: utf-8
class TestGraphData
  def upload
    Student.find_by(email: 'vl@coalla.ru').try(:destroy)
    Instructor.find_by(email: 'test@coalla.ru').try(:destroy)

    ActiveRecord::Base.transaction do
      student = Student.create!(email: 'vl@coalla.ru', password: 'vl@coalla.ru', first_name: 'Владимир', last_name: 'Владимиров')
      instructor = Instructor.create!(email: 'test@coalla.ru', password: 'test123456', first_name: 'Тест', last_name: 'Тестович')

      2.times do |i|
        create_course_data(instructor, student, i)
      end
    end
  end

  def create_course_data(instructor, student, idx)
    days_count = 30

    course = Course.create!(name: "Тестирование графиков #{idx}", active: true)
    block = course.blocks.create!(name: "Блок #{idx} для тестирования графиков #{idx}")

    6.times do |i|
      block.lectures.create!(description: "Лекция #{i + 1}. Графики #{idx}")
    end

    task_types = [EssayTask, TextTask, ConnectionTask, CalculationTask, FileTask, TestTask]

    block.lectures.to_a.each_with_index do |lecture, idx|
      type = task_types[idx]
      send("create_#{type.to_s.underscore}!", lecture)
    end

    group = course.groups.create!(course: course, instructor: instructor, title: 'Тестирование графиков')

    start = Date.today - days_count

    student.group_subscriptions.create!(group: group, begin_on: start, end_on: Date.today + 5.days)

    1.upto(days_count) do |i|
      date = start + i.days
      lecture = course.lectures.first
      UserActivity.create!(student: student, title: 'Тестирование', description: lecture.description, trackable: lecture, spent_time: rand(7600), last_tracked_at: date)
    end

    start += 1.day

    course.tasks.find_each do |task|
      result = task.new_result_model(user: student)
      activity = UserActivity.create!(student: student, title: "Задание №#{task.lecture.lecture_index}", description: result.description_for_activity, spent_time: rand(7600), last_tracked_at: start + rand(29))
      result.user_activities << activity
      send("mark_#{result.type.underscore}!", result, instructor)
      activity.update!(student: student, title: "Задание №#{task.lecture.lecture_index}", description: result.description_for_activity, trackable: result, spent_time: rand(7600), last_tracked_at: start + rand(29))
    end
  end

  #tasks

  def create_calculation_task!(lecture)
    lecture.create_task!(type: 'CalculationTask', title: 'Задание на рассчёт', description: '2*2 = ?', answer: 4)
  end

  def create_connection_task!(lecture)
    connection_task = lecture.create_task!(type: 'ConnectionTask', title: 'Задание на соединение', description: 'Соедините блоки')
    digits = connection_task.columns.create!(title: 'Цифры')
    words = connection_task.columns.create!(title: 'Слова')
    symbols = connection_task.columns.create!(title: 'Сиволы')

    digits.column_variants.create!(title: 1)
    words.column_variants.create(title: 'Эхо')
    symbols.column_variants.create(title: '$')
  end

  def create_file_task!(lecture)
    lecture.create_task!(type: 'FileTask', title: 'Задание на загрузку файлов', description: 'Загрузите ваши лучшие фотографии')
  end

  def create_essay_task!(lecture)
    lecture.create_task!(type: 'EssayTask', title: 'Задание-сочинение', description: 'Опишите всё, о чём думаете в данную минуту')
  end

  def create_text_task!(lecture)
    lecture.create_task!(type: 'TextTask', title: 'Задание-сочинение', description: 'Просто напишите здесь что-нибудь')
  end

  def create_test_task!(lecture)
    test_task = lecture.create_task!(type: 'TestTask', title: 'Тест', description: 'Отвтетьте на вопросы теста', items_count: 3)
    3.times do |i|
      question = test_task.questions.create!(title: 'Ответьте ' + i.to_s)
      question.question_answers.create!(title: i)
      4.upto(6) do |j|
        question.question_answers.create!(title: j.to_s)
      end
    end
  end

  #results

  def mark_result_calculation!(result, instructor)
    result.answer = 4
    result.mark_result!
  end

  def mark_result_connection!(result, instructor)
    task = result.task
    result.save!

    task.columns.find_each do |c|
      result.result_connection_items.build(column: c, column_variant: task.column_variants.first)
    end

    result.mark_result!
  end

  def mark_result_file!(result, instructor)
    result.result_file_items.build(file: File.open(File.join(Rails.root, 'app/assets/images/share.jpg')))
    result.mark_result!(mark: 30, instructor: instructor)
  end

  def mark_result_essay!(result, instructor)
    result.answer = 'Я написал здесь что-то, а вы поставьте мне оценку'
    result.mark_result!(mark: 80, instructor: instructor)
  end

  def mark_result_text!(result, instructor)
    result.answer = 'Я написал здесь всё, что смог и не смог, а вы поставьте мне оценку'
    result.mark_result!(mark: 50, instructor: instructor)
  end

  def mark_result_test!(result, instructor)
    result.task.questions.find_each do |q|
      result.result_test_items.build(question: q, question_answer: q.question_answers.first)
    end

    result.mark_result!
  end
end