# frozen_string_literal: true

feature 'The user can create question', %q{
  In order to get answers to find out the information
  As an authenticated user
  I would like to be able to ask a question
}, type: :feature, aggregate_failures: true do

  given(:user) { create(:user) }

  describe 'Authenticated user tries to ask a question' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'with valid data' do
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Text in the question body'
      click_on 'Ask'

      expect(page).to have_content('Your question has been successfully created!')
      expect(page).to have_content('Question title')
      expect(page).to have_content('Text in the question body')
    end

    scenario 'with invalid data' do
      click_on 'Ask'

      expect(page).to have_content('Title can\'t be blank')
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path

    expect(page).to_not have_link(new_question_path)
  end
end
