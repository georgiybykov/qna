# frozen_string_literal: true

feature 'The user can add links to the question', %q{
  In order to provide an additional information
  As an author of the question
  I would like to be able to add links
}, type: :feature, js: true, aggregate_failures: true do

  given(:user) { create(:user) }
  given(:first_url) { 'https://first-example.com/new' }
  given(:second_url) { 'https://second-example.com/show' }
  given(:gist_url) { 'https://gist.github.com/georgiybykov/example' }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Text in the question body'
    end

    scenario 'adds a valid link when asks a question' do
      fill_in 'Link name', with: 'New Link'
      fill_in 'URL', with: first_url

      click_on 'Ask'

      expect(page).to have_link 'New Link', href: first_url
    end

    scenario 'adds an invalid link when asks a question' do
      fill_in 'Link name', with: 'Invalid Link'
      fill_in 'URL', with: 'Invalid URL'

      click_on 'Ask'

      expect(page).to have_content 'Links url is not a valid URL'
      expect(page).to_not have_content 'Invalid Link'
      expect(page).to_not have_content 'Invalid URL'
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

    scenario 'adds a link to GitHub Gist when asks a question' do
      fill_in 'Link name', with: 'Link to gist'
      fill_in 'URL', with: gist_url

      click_on 'Ask'

      expect(page).not_to have_link 'Link to gist', href: gist_url
    end
  end

  scenario 'Unauthenticated user tries to create a question with the attached link' do
    visit new_question_path

    expect(page).not_to have_button 'Add link'
    expect(page).not_to have_button 'Ask'

    expect(page).to have_content 'Sign in'
  end
end
