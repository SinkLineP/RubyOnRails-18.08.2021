class BlockCloningJob
  attr_reader :block_id

  def initialize(block_id)
    @block_id = block_id
  end

  def perform
    @block = Block.find(block_id)
    @new_block = @block.dup
    @new_block.save!
    lectures = @block.lectures
    lectures_count = lectures.count
    lectures.each_with_index{ |lecture, idx| Delayed::Job.enqueue(LectureCloningJob.new(@new_block.id, lecture.id, lectures_count == idx + 1)) }
  end

  def failure(job)
    error = StandardError.new("Unable to clone block. Job #{job.id}")
    error.set_backtrace(job.last_error)
    CustomExceptionNotifier.notify_exception(error)
  end

end