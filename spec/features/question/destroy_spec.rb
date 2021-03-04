# frozen_string_literal: true

feature 'The user can delete the question', %q{
  In order to clear the history of the questions
  As an authenticated user
  I would like to be able to delete the question
}, type: :feature, aggregate_failures: true do

  given(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    scenario 'tries to delete the question of the other user' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete question'
    end

    scenario 'tries to delete his own question' do
      sign_in(question.user)

      visit questions_path
      expect(page).to have_content question.title
      expect(page).to have_content question.body

      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'Your question has been successfully deleted!'

      visit questions_path
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end
  end

  scenario 'Unauthenticated user tries to delete the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
