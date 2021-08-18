# == Schema Information
#
# Table name: notice_groups
#
#  id         :integer          not null, primary key
#  notice_id  :integer
#  group_id   :integer
#  position   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_notice_groups_on_group_id                (group_id)
#  index_notice_groups_on_notice_id               (notice_id)
#  index_notice_groups_on_notice_id_and_group_id  (notice_id,group_id) UNIQUE
#


class NoticeGroup < ActiveRecord::Base
  belongs_to :group, inverse_of: :notice_groups
  belongs_to :notice, inverse_of: :notice_groups
end
