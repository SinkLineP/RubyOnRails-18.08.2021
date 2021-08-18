require 'csv'
require 'securerandom'
require 'charlock_holmes/string'

class ImportService

  def initialize
    @messages = []
  end

  def run(file_name)
    file = format_file(file_name)
    csv = CSV.new(file, row_sep: :auto, col_sep: ';')
    csv.each do |csv|
      student = find_or_initialize_student(csv)
      group = find_group(csv)

      unless student_signed_at?(student, group)
        student.group_subscriptions.build(group: group,
                                          begin_on: s_squish(csv[5]),
                                          end_on: s_squish(csv[6])) if group
      end

      unless student.save
        send_log("Ошибка импорта пользователя: #{student.errors.full_messages}") if student.errors.any?
      end
    end
  rescue => ex
    send_log('Не удалось загрузить файл. Проверьте его формат.')
    Rails.logger.error("Import error: #{ex.message}")
  end

  def full_messages
    @messages
  end

  private

  def format_file(file_name)
    file = File.read(file_name)
    encoding = file.detect_encoding[:encoding]
    file.encode('utf-8', encoding, universal_newline: true)
  end

  def find_or_initialize_student(csv)
    student = Student.find_or_initialize_by(email: s_squish(csv[2]))
    if student.new_record?
      student.assign_attributes({
                                    password: SecureRandom.hex[0..8],
                                    phone: s_squish(csv[1])
                                }.merge(get_fio(csv[0])))
    end
    student
  end

  def find_group(csv)
    group_title = s_squish(csv[4])
    group = Group.find_by(title: group_title)
    send_log("Группа \"#{group_title}\" не найдена ...") unless group
    group
  end

  def student_signed_at?(student, group)
    group && student.group_subscriptions.where(group_id: group.id).any?
  end

  def get_fio full_name
    names = s_squish(full_name).split(' ')
    {last_name: names.first, first_name: names.second}
  end

  def s_squish(text)
    text.to_s.squish
  end

  def check_mail_type(student, subscription)
    if student.changed?
      :sign_up
    elsif subscription.present?
      :new_subscription
    end
  end

  def send_log(message)
    @messages << message
  end
end