LectureCloningJob = Struct.new(:block_id, :lecture_id, :send_mail, :copy) do

  def perform
    block = Block.find(block_id)
    lecture = Lecture.find(lecture_id)
    block.lectures << lecture.deep_dup
    block.save!
    if send_mail.present?
      if copy.present?
        CosmetologyMailer.block_cloned(block).deliver!
      else
        CosmetologyMailer.block_copied(block, lecture.block).deliver!
      end
    end
  end

  def failure(job)
    error = StandardError.new("Unable to clone lecture. Job #{job.id}")
    error.set_backtrace(job.last_error)
    CustomExceptionNotifier.notify_exception(error)
    if send_mail.present?
      block = Block.find(block_id)
      CosmetologyMailer.block_cloned(block).deliver!
    end
  end
end
