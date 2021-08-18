require 'net/imap'

class LettersLoader
  include Logs
  # почтовые ящики преподавателей зарегистрированы на google

  MAX_UID = 1073741823

  CRITERIA_NAMES = {
    inbound: 'FROM',
    outbound: 'TO'
  }

  def initialize(instructor)
    @instructor = instructor
    @client = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
    @logger = ActiveSupport::Logger.new("#{Rails.root}/log/letters.log")
    @logger.formatter = Logger::Formatter.new
  end

  def load!
    log_message("Load messages for instructor: #{@instructor.id}, #{@instructor.email}...")
    if @instructor.students.blank?
      log_message('Nothing to load.')
      return
    end
    return unless connect
    log_message('Connected to mail service.')
    log_message('Load inbound...')
    load_letters!(:inbound)
    log_message('Load outbound...')
    load_letters!(:outbound)
    log_message('Loading finished.')
    disconnect
  end

  private

  def connect
    @login ||= @client.login(@instructor.email, @instructor.email_password)
  rescue => ex
    log_error("Couldn't connect to mail service for #{@instructor.email}", ex)
    false
  end

  def disconnect
    @client.logout
    @client.disconnect
  rescue => ex
    log_error("Couldn't disconnect from mail service for #{@instructor.email}", ex)
  end

  def load_letters!(folder)
    mailbox = send("#{folder}_folder_name")
    @client.examine(mailbox)

    last_letter_uid = @instructor.last_letter_uid(folder)

    @instructor.students.find_in_batches(batch_size: 30) do |students|
      threads = []
      students.each do |student|
        search_criteria = []
        search_criteria += ['UID', "#{last_letter_uid + 1}:#{MAX_UID}"] if last_letter_uid.present?
        criteria_name = CRITERIA_NAMES[folder]
        search_criteria += [criteria_name, student.email]
        threads << Thread.new do
          uids = @client.uid_search(search_criteria)
          log_message("Loading letters for #{student.email}...")
          create_letters!(student, uids, folder)
          log_message("Loading letters for #{student.email} finished")
        end
      end
      threads.each(&:join)
    end

    log_message('Loading service letters...')
    load_service_letters!(last_letter_uid, folder) if folder == :inbound
    log_message('Loading service letters finished')
  rescue => ex
    log_error("Couldn't load letters for #{@instructor.email}, folder #{folder}", ex)
    raise
  end

  def load_service_letters!(last_uid, folder)
    search_criteria = []
    search_criteria += ['UID', "#{last_uid + 1}:#{MAX_UID}"] if last_uid.present?
    criteria_name = CRITERIA_NAMES[folder]
    search_criteria += [criteria_name, 'no-reply@cosmetic.coalla.ru']
    uids = @client.uid_search(search_criteria)
    create_letters!(nil, uids, folder)
  end

  def create_letters!(student, uids, folder)
    return if uids.blank?

    @client.uid_fetch(uids, %w(UID RFC822 FLAGS)).each do |letter|
      uid = letter.attr['UID']
      mail = Mail.read_from_string(letter.attr['RFC822'])
      read = false #letter.attr['FLAGS'].any? { |flag| flag == Net::IMAP::SEEN }

      # workaround for reply_to
      if student.nil? && mail.reply_to.try(:first).present?
        student = Student.find_by(email: mail.reply_to.first)
      end

      next if student.blank?

      l = Letter.find_by(message_id: mail.message_id)
      if l.present?
        l.update_column(:uid, uid) if l.uid.blank?
        next
      end

      part = mail.multipart? ? (mail.text_part || mail.html_part) : mail
      part ||= mail
      /charset=(?<charset>[^\s]+)\s?/ =~ part.content_type
      body = part.body.decoded.force_encoding(charset ? charset.gsub('"', '').gsub(';', '') : 'iso-8859-1').encode('UTF-8')

      l = Letter.create!(instructor: @instructor,
                         student: student,
                         folder: folder,
                         subject: mail.subject,
                         body: body,
                         read: read,
                         sent_at: mail.date,
                         uid: uid,
                         message_id: mail.message_id)

      mail.attachments.each do |attachment|
        file = StringIO.new(attachment.decoded)
        file.class.class_eval { attr_accessor :original_filename, :content_type }
        file.original_filename = attachment.filename
        file.content_type = attachment.mime_type
        l.attachments.create!(item: file)
      end
    end
  end

  def outbound_folder_name
    folders = @client.list('*', '*')
    folder = folders.select { |d| d.attr.include? :Sent }.first
    folder.name || '[Gmail]/Sent Mail'
  end

  def inbound_folder_name
    folders = @client.list('*', '*')
    folder = folders.select { |d| d.name == 'INBOX' }.first
    folder.name || 'INBOX'
  end
end
