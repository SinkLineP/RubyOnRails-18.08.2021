# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  type                      :string
#  email                     :string           default(""), not null
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :inet
#  last_sign_in_ip           :inet
#  created_at                :datetime
#  updated_at                :datetime
#  first_name                :text
#  last_name                 :text
#  delta                     :boolean          default(TRUE), not null
#  avatar                    :text
#  demo                      :boolean          default(FALSE), not null
#  hide_tutorial             :boolean          default(FALSE), not null
#  encrypted_email_password  :text
#  middle_name               :text
#  birthday                  :date
#  translit_name             :text
#  phones                    :text             default([]), is an Array
#  emails                    :text             default([]), is an Array
#  education_level_id        :integer
#  passport_series           :text
#  passport_number           :text
#  passport_issued_on        :date
#  passport_organisation     :text
#  passport_address          :text
#  address                   :text
#  amocrm_id                 :text
#  imported_from_amo         :boolean          default(FALSE), not null
#  welcome_sent_at           :datetime
#  comagic_campaign          :text
#  update_job_id             :integer
#  wear_size                 :text
#  version                   :integer          default(0), not null
#  campaign_id               :integer
#  amo_created_at            :datetime
#  description               :text
#  subscribed_on_blog        :boolean          default(FALSE)
#  wordpress_id              :integer
#  phone_added_at            :datetime
#  deleted_at                :datetime
#  shop_id                   :integer
#  privacy_policy_confirmed  :boolean          default(FALSE), not null
#  notified_about_requisites :boolean          default(FALSE), not null
#  source                    :string           default("none"), not null
#
# Indexes
#
#  index_users_on_amocrm_id_and_email_and_emails_and_phones  (amocrm_id,email,emails,phones)
#  index_users_on_campaign_id                                (campaign_id)
#  index_users_on_education_level_id                         (education_level_id)
#  index_users_on_email                                      (email) UNIQUE
#  index_users_on_reset_password_token                       (reset_password_token) UNIQUE
#  index_users_on_shop_id                                    (shop_id)
#

class Manager < User
end
