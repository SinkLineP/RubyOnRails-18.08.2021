class AddPrivacyPolicyToOffer < ActiveRecord::Migration
  def up
    HtmlItem.create!(page: 'privacy_policy',
                     title: 'Политика использования персональных данных',
                     description: '',
                     content: '')
  end

  def down
    HtmlItem.where(page: 'privacy_policy').destroy_all
  end
end
