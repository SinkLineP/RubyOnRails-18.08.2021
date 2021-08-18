# == Schema Information
#
# Table name: old_urls
#
#  id         :integer          not null, primary key
#  url        :text             not null
#  new_url    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OldUrl < ActiveRecord::Base

  class << self
    def get_url(url)
      old_url = OldUrl.where('lower(url)=?', url.downcase).first
      old_url.try(:new_url)
    end

    def get_url!(url)
      old_url = OldUrl.where('lower(url)=?', url.downcase).first!
      old_url.new_url
    end
  end

end
