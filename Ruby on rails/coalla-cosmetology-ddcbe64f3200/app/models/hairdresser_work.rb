# == Schema Information
#
# Table name: works
#
#  id                     :integer          not null, primary key
#  title                  :text
#  appendix               :text
#  type                   :text
#  form_sheet             :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  criterion              :text
#  duration               :integer          default(0), not null
#  break_days             :integer          default(0), not null
#  hairdresser_form_sheet :text
#  statement_criterion    :text
#

class HairdresserWork < Work
end
