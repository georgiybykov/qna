# frozen_string_literal: true

feature 'The user can add links to the question', %q{
  In order to provide an additional information
  As an author of the question
  I would like to be able to add links
}, type: :feature, js: true, aggregate_failures: true do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/georgiybykov/65dc44ab3be2a8a1354ab90b3e5d1793' }

  scenario 'Authenticated user adds a link when asks a question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Text in the question body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'URL', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
