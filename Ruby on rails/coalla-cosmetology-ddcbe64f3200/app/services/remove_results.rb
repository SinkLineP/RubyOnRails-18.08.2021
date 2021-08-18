class RemoveResults
  def self.all(lecture_id)
    lecture = Lecture.find(lecture_id)
    tasks = lecture.block.lectures.where('position >= ?', lecture.position).map { |l| l.task }
    Result.where(task_id: tasks.map(&:id)).destroy_all
    tasks.each do |task|
      task.update(type: 'TestTask')
    end
  end

  def self.one(lecture_id)
    task = Lecture.find(lecture_id).task
    Result.where(task: task).destroy_all
    task.update(type: 'TestTask')
  end
end