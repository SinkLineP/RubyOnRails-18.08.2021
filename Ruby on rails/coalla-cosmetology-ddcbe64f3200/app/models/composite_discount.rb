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

class CompositeDiscount < Discount
  def calculate(amount)
    [amount, discounts.to_a.sum { |d| d.calculate(amount) }].min.ceil
  end
end
