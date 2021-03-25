# frozen_string_literal: true

feature 'The user can add links to the answer', %q{
  In order to provide an additional information
  As an author of the answer
  I would like to be able to add links
}, type: :feature, js: true, aggregate_failures: true do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/georgiybykov/65dc44ab3be2a8a1354ab90b3e5d1793' }

  scenario 'Authenticated user adds a link when makes an answer' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'Answer to the question'

    fill_in 'Link name', with: 'My gist'
    fill_in 'URL', with: gist_url

    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
