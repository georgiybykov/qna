# frozen_string_literal: true

feature 'The user can add links to the answer', %q{
  In order to provide an additional information
  As an author of the answer
  I would like to be able to add links
}, type: :feature, js: true, aggregate_failures: true do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/georgiybykov/65dc44ab3be2a8a1354ab90b3e5d1793' }
  given(:first_url) { 'https://first-aexample.com/new' }
  given(:second_url) { 'https://second-aexample.com/show' }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'Your answer', with: 'Answer to the question'
    end

    scenario 'adds a link when makes an answer' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'URL', with: gist_url

      click_on 'Create answer'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end
    end

    scenario 'adds a couple of links when makes an answer' do
      fill_in 'Link name', with: 'First Link'
      fill_in 'URL', with: first_url

      click_on 'Add link'

      page.all('.nested-fields').first.fill_in 'Link name', with: 'Second Link'
      page.all('.nested-fields').first.fill_in 'URL', with: second_url

      click_on 'Create answer'

      within '.answers' do
        expect(page).to have_link 'First Link', href: first_url
        expect(page).to have_link 'Second Link', href: second_url
      end
    end
  end

  scenario 'Unauthenticated user tries to create an answer with the attached link' do
    visit question_path(question)

    expect(page).to_not have_button 'Add link'
    expect(page).to_not have_button 'Create Answer'
  end
end
