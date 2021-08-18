# == Schema Information
#
# Table name: discounts
#
#  id         :integer          not null, primary key
#  title      :text
#  type       :text
#  value      :float            default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  archival   :boolean          default(FALSE), not null
#

class PercentDiscount < Discount
  def calculate(amount)
    [amount, amount * (value / 100.0)].min.ceil
  end
end
