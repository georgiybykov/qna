# frozen_string_literal: true

feature 'The user can add links to the question', %q{
  In order to provide an additional information
  As an author of the question
  I would like to be able to add links
}, type: :feature, js: true, aggregate_failures: true do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/georgiybykov/65dc44ab3be2a8a1354ab90b3e5d1793' }
  given(:first_url) { 'https://first-aexample.com/new' }
  given(:second_url) { 'https://second-aexample.com/show' }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Text in the question body'
    end

    scenario 'adds a link when asks a question' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'URL', with: gist_url

      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'adds a couple of links when asks a question' do
      fill_in 'Link name', with: 'First Link'
      fill_in 'URL', with: first_url

      click_on 'Add link'

      page.all('.nested-fields').first.fill_in 'Link name', with: 'Second Link'
      page.all('.nested-fields').first.fill_in 'URL', with: second_url

      click_on 'Ask'

      expect(page).to have_link 'First Link', href: first_url
      expect(page).to have_link 'Second Link', href: second_url
    end
  end

  scenario 'Unauthenticated user tries to create a question with the attached link' do
    visit new_question_path

    expect(page).to_not have_button 'Add link'
    expect(page).to_not have_button 'Ask'

    expect(page).to have_content 'Log in'
  end
end
