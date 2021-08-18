AmocrmImportJob = Struct.new(:amocrm_import_id) do
  def perform
    errors = Amocrm::FullImport.new.run
    import.update_columns(completed: true, completed_at: Time.current, errors_string: errors.present? ? errors.to_s : nil) if import
    logger = Logger.new("#{Rails.root}/log/amo_import.log")
    logger.error('При импорте из AMOcrm произошли ошибки !')
    errors.each { |object, error| logger.error("Импорт объекта с id #{object.id}. Сообщение об ошибке: #{error.message}.\n#{error.backtrace.join('<br/>')}") }
  end

  def failure(job)
    import.update_columns(completed: true, completed_at: Time.current, errors_string: job.last_error, job_id: job.id) if import
  end

  def import
    @import ||= AmocrmImport.find_by(id: amocrm_import_id)
  end

  def max_attempts
    1
  end
end