class MailService
  # почтовые ящики преподавателей зарегистрированы на google

  DOMAIN = 'cosmeticru.com'

  require 'net/smtp'

  def initialize(letter)
    @letter = letter
  end

  def send_mail!
    msg = build_mail

    smtp = Net::SMTP.new('smtp.gmail.com', 587)
    smtp.enable_starttls
    smtp.start(DOMAIN, @letter.instructor.email, @letter.instructor.email_password, :login) do
      smtp.send_message(msg, @letter.instructor.email, @letter.student.email)
    end

    @letter.message_id = message_id
    @letter.save!
  end

  private

  def build_mail
    @mail = Mail.new
    @mail.subject = @letter.subject
    @mail.body = @letter.body
    @mail.bcc = copy_mail
    @mail.to = @letter.student.email
    @mail.from = @letter.instructor.email
    @mail.to_s
  end

  def copy_mail
    Rails.env.staging? ? 'dev@coalla.ru' : 'cosmeticru@mail.amocrm.ru'
  end

  def message_id
    @mail.try(:message_id)
  end
end