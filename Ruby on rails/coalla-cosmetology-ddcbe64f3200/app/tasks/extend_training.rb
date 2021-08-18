class ExtendTraining

  def self.run
    Student.joins(:group_subscriptions).where(group_subscriptions: {end_on: Date.today - 5.month - 2.week}).distinct.find_each do |student|
      CosmetologyMailer.notify_extend_training(student).deliver_later
    end
  end

end