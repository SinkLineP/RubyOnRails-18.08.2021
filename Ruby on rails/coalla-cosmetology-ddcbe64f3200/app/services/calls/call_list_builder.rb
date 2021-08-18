module Calls
  class CallListBuilder
    def initialize(call_results)
      @call_results = call_results
      @host = Rails.application.secrets.host
    end

    def build
      CSV.generate(col_sep: ';') do |csv|
        csv << %w(callResultId phoneNumber messageUrl ivrPromptUrl webhookUrl)
        @call_results.each do |call_result|
          group_subscription = call_result.group_subscription
          phone = group_subscription.student.phone
          course = group_subscription.course
          next unless course.notification_audio?
          next if phone.blank?
          csv << [
            call_result.id,
            phone.dup.tap { |phone| phone[0] = '7' },
            URI.join(@host, course.notification_audio_url),
            URI.join(@host, course.ivr_audio_url),
            Rails.application.routes.url_helpers.call_results_url(host: @host)
          ]
        end
      end
    end
  end
end