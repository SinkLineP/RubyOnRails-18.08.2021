CopyBlockJob = Struct.new(:block_id, :new_block_id) do
  def perform
    @block = Block.find(block_id)
    @new_block = Block.find(new_block_id)
    lectures = @block.lectures
    lectures_count = lectures.count
    lectures.each_with_index{ |lecture, idx| Delayed::Job.enqueue(LectureCloningJob.new(@new_block.id, lecture.id, lectures_count == idx + 1), true) }
  end

  def failure(job)
    error = StandardError.new("Unable to copy block. Job #{job.id}")
    error.set_backtrace(job.last_error)
    CustomExceptionNotifier.notify_exception(error)
  end

end