class AddContactPage < ActiveRecord::Migration
  def up
    StaticPage.create!(slug: :contacts, title: 'КОНТАКТЫ', content: '<p><span>+7 (495) 236-89-29&nbsp;</span><span>info@cosmeticru.com</span></p><p>Москва, Лялин переулок, дом 3, строение 3</p>', permanent: true)
  end

  def down
    StaticPage.find_by(slug: :contacts).destroy
  end
end
