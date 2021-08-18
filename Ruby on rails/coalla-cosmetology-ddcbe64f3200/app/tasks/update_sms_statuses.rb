class UpdateSmsStatuses
  def self.do
    Sms.where(status: 0).find_each do |sms|
      sms.update_status!
    end
  end
end