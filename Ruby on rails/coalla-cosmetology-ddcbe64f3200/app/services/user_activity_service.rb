class UserActivityService
  MAX_TIME_DELTA = 15.minutes
  LEAVING_EVENT_TYPE = 'leaving'
  LEARNING_EVENT_TYPE = 'learning'

  def self.track(user, options)
    service = new(user, options)
    if options[:event_type] == LEAVING_EVENT_TYPE
      service.create_user_activity
      return
    end
    service.track_activity
    service.track_total_activity
  end

  def initialize(user, options)
    @user, @title, @description, @time, @event_type = user, options[:title], options[:description], Time.now, options[:event_type]
    @trackable =
        if options[:trackable_id].present? && options[:trackable_type].present?
          options[:trackable_type].constantize.find(options[:trackable_id])
        end
  end

  def track_activity
    user_activity = last_user_activity
    if user_activity
      time_delta = @time - user_activity.last_tracked_at
      if time_delta < MAX_TIME_DELTA
        update_time(user_activity, time_delta)
      else
        create_user_activity
      end
    else
      create_user_activity
    end
  end

  def track_total_activity
    activity = @user.user_total_activity
    if activity
      last_tracked_at = activity.last_tracked_at
      unless last_tracked_at.today?
        activity.today_spent_time = 0
      end

      time_delta = @time - last_tracked_at
      if time_delta < MAX_TIME_DELTA
        if last_tracked_at.today?
          activity.today_spent_time+= time_delta
        end
        activity.spent_time += time_delta
      end
      activity.last_tracked_at = @time
      activity.save!
    else
      create_user_total_activity
    end
  end

  def create_user_activity
    @user.user_activities.create(title: @title,
                                 description: @description,
                                 last_tracked_at: @time,
                                 trackable: @trackable,
                                 event_type: @event_type || LEARNING_EVENT_TYPE)
  end

  private

  def update_time(user_activity, time_delta)
    user_activity.with_lock do
      user_activity.spent_time += time_delta
      user_activity.last_tracked_at = @time
      user_activity.save!
    end
  end

  def last_user_activity
    @user.user_activities.where(title: @title, description: @description).where.not(event_type: LEAVING_EVENT_TYPE).first
  end

  def create_user_total_activity
    @user.create_user_total_activity(last_tracked_at: @time)
  end

end