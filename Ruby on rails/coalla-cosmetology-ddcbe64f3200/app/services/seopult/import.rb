module Seopult
  class Import

    attr_reader :client, :begin_on, :end_on, :campaigns

    def initialize(begin_on = Date.current, end_on = Date.current)
      @client = Client.new
      @begin_on = begin_on
      @end_on = end_on
      @campaigns = Campaign.seopult.to_a
    end

    def run!
      (begin_on..end_on).each do |date|
        stats = client.projects_stats(date)

        @campaigns.each do |campaign|
          charge = campaign.indices.find_or_initialize_by(name: :charges,
                                                          service: :seopult,
                                                          created_on: date)
          charge.value = stats['Money'].blank? ? 0 : stats['Money'][campaign.seopult_id].to_f.round(2).abs
          charge.save!
        end
      end
    end


  end
end