# == Schema Information
#
# Table name: linked_discounts
#
#  id          :integer          not null, primary key
#  parent_id   :integer
#  discount_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_linked_discounts_on_discount_id                (discount_id)
#  index_linked_discounts_on_parent_id                  (parent_id)
#  index_linked_discounts_on_parent_id_and_discount_id  (parent_id,discount_id) UNIQUE
#

class LinkedDiscount < ActiveRecord::Base
  belongs_to :parent, class_name: :Discount, foreign_key: :parent_id
  belongs_to :discount
end
