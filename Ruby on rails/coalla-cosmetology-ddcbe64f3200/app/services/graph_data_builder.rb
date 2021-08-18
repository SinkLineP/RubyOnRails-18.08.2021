class GraphDataBuilder
  def initialize(course_activities)
    @course_activities = course_activities
  end

  def activity_graph_data
    return {} if @course_activities.blank?

    {
        beginOn: begin_on,
        endOn: end_on,
        spentTime: spent_time,
        results: success_results
    }
  end

  def results_graph_data
    return {} if @course_activities.blank?

    {
        beginOn: begin_on,
        endOn: end_on,
        results: all_results
    }
  end

  protected

  def begin_on
    @begin_on ||= @course_activities.first.last_tracked_at.to_date
  end

  def end_on
    @end_on ||= @course_activities.last.last_tracked_at.to_date
  end

  def spent_time
    @spent_time ||= @course_activities
                        .group_by { |a| a.last_tracked_at.to_date }
                        .flat_map { |date, activities| {date: date, hours: activities.sum(&:spent_time)} }
  end

  def success_results
    @success_results ||= @course_activities.select { |user_activity| user_activity.result? && user_activity.trackable.passed? }.map do |a|
      {date: a.last_tracked_at.to_date,
       hours: spent_time.find { |data| data[:date] == a.last_tracked_at.to_date }[:hours]}
    end
  end

  def all_results
    @all_results ||= @course_activities
                         .select { |user_activity| user_activity.result? && user_activity.trackable.marked? }
                         .map { |user_activity| {resultId: user_activity.trackable_id,
                                                 studentId: user_activity.trackable.student_id,
                                                 date: user_activity.last_tracked_at.to_date,
                                                 percent: user_activity.trackable.percent,
                                                 description: user_activity.description,
                                                 passed: user_activity.trackable.passed} }
  end
end