module TimeControl
  module Reports
    class BuildJob
      class << self
        def enqueue(params)
          ::Delayed::Job.enqueue(new(params))
        end
      end

      def initialize(params)
        @params = params.with_indifferent_access
      end

      def perform
        path = ReportBuilder.new(@params).save
        ::CosmetologyMailer.report_ready(@params[:email], path).deliver!
      end

      def failure(job)
        error = StandardError.new("Unable to generate attendance report. Job #{job.id}")
        error.set_backtrace(job.last_error)
        ::CustomExceptionNotifier.notify_exception(error)
      end

      def max_attempts
        1
      end
    end
  end
end