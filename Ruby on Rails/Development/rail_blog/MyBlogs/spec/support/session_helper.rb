def sign_up
  visit new_user_registration_path

  fill_in :user_username, with: 'FooBar'
  fill_in :user_email, with: 'foo@bar.com'
  fill_in :user_password, with: '1234567'
  fill_in :user_password_confirmation, with: '1234567'

  click_button 'Sign up'
end

def create_new_article
  visit new_article_path

  fill_in :article_title, with: 'Hello!'
  fill_in :article_text, with: 'Hello user'

  click_button('Опубликовать')
end  