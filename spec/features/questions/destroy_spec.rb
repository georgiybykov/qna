# frozen_string_literal: true

feature 'The user can delete the question', %q{
  In order to clear the history of the questions
  As an authenticated user
  I would like to be able to delete the question
}, type: :feature, js: true, aggregate_failures: true do

  given!(:question) { create(:question) }
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(question.user)

      visit questions_path
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'tries to delete his own question from the page of the question' do
      visit question_path(question)

      accept_confirm { click_on 'Delete question' }

      click_on 'QnA'
      expect(current_path).to eq questions_path

      expect(page).not_to have_content question.title
      expect(page).not_to have_content question.body
    end

    scenario 'tries to delete his own question from the main page of the resource' do
      click_on 'Delete'

      expect(current_path).to eq questions_path

      expect(page).not_to have_content question.title
      expect(page).not_to have_content question.body
    end
  end

  scenario 'Authenticated user tries to delete the question of the other user' do
    sign_in(user)
    visit question_path(question)

    expect(page).not_to have_link 'Delete question'
  end

  scenario 'Unauthenticated user tries to delete the question' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete question'
  end
end
