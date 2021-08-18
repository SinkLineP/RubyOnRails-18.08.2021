module GroupSubscriptions
  class AmoLeadActionJob

    attr_accessor :action, :params

    class << self
      def enqueue(action, params)
        Delayed::Job.enqueue(GroupSubscriptions::AmoLeadActionJob.new(action, params), queue: :amocrm)
      end
    end

    def initialize(action, params = {})
      @action = action
      @params = params
    end

    def perform
      AmoLead.new(params).send(action)
    end

    def failure(job)
      return if Rails.env.development?
      error = StandardError.new("Unable to #{action} amoCRM lead. Job #{job.id}")
      error.set_backtrace(job.last_error)
      CustomExceptionNotifier.notify_exception(error)
    end

    def max_attempts
      2
    end
  end
end