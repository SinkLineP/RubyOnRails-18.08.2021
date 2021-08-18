CreatePdfImages = Struct.new(:id, :class_name) do
  def perform
    item = class_name.constantize.find(id)
    item.create_pdf_images
  end

  def failure(job)
    error = StandardError.new("Unable to create PDF #{class_name} #{id}. Job #{job.id}.")
    error.set_backtrace(job.last_error)
    CustomExceptionNotifier.notify_exception(error)
  end
end