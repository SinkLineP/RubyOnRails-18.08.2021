class OldJobsService
  def self.run
    Delayed::Job.where('created_at < ?', Date.current - 7.days).destroy_all
  end
end