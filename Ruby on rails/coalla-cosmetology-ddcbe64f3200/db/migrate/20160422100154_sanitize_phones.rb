class SanitizePhones < ActiveRecord::Migration
  def up
    User.where.not(phones: nil).find_each do |user|
      user.update_columns(phones: user.phones.reject(&:blank?).map{|p| p.try(:gsub, /[-+()\s]/, '')}.reject(&:blank?))
    end
  end

  def down
  end
end
