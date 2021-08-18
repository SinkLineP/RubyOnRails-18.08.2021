require "rails_helper"

feature "Article create" do
  before(:each) do
    sign_up
    create_new_article 
  end

  scenario "allows user to visit new article page" do
    visit new_article_path
    expect(page).to have_content 'New Article'
    fill_in :article_title, with: 'Hello'
    fill_in :article_text, with: 'Hello user'
    click_button('Опубликовать!')
    expect(page).to have_content 'Hello'
  end 

  scenario "allows user to edit article" do
    visit articles_path
    click_link('Show article')
    click_link('Edit Article')
    expect(page).to have_content 'Edit Article'
    fill_in :article_title, with: 'Hello!!!'
    fill_in :article_text, with: 'Hello user'

    click_button('Опубликовать!')
    expect(page).to have_content 'Hello!!!'

  end

end
