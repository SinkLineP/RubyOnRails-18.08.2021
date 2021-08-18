class CourseStatistics
  def initialize
    @course = Course.find_by(short_name: 'IK')
    @lectures = @course.lectures
    @begin_on = Date.new(2017, 4, 1)
    @end_on = Date.new(2018, 3, 31)
    @scope = GroupSubscription.with_deleted.actual.joins(:group).where(sale_success_on: @begin_on..@end_on, group: @course.groups)
  end

  def build
    {
      total: total,
      lectures_info: lectures_info
    }
  end

  private

  def total
    @scope.count
  end

  def lectures_info
    info = UserActivity.where(trackable: @course.lectures,
                              user_id: @scope.select(:student_id))
             .select('trackable_id, count(distinct user_id) as count, SUM(spent_time)/COUNT(trackable_id) as time')
             .group(:trackable_id)
             .order(:trackable_id)
             .map { |a| [a.trackable_id, a.count, (a.time / 60.0).round(2)] }

    info.map do |item|
      lecture = Lecture.find(item[0])
      block = lecture.block
      ["#{block.name}. #{lecture.title}".strip.squish] + item[1..-1]
    end
  end
end