# frozen_string_literal: true

feature 'The user can delete the answer', %q{
  In order to clear the history of the answers
  As an authenticated user
  I would like to be able to delete the answer for the question
}, type: :feature, js: true, aggregate_failures: true do

  given(:answer) { create(:answer) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    scenario 'tries to delete the answer of the other user' do
      sign_in(user)
      visit question_path(answer.question)

      expect(page).to_not have_link 'Delete answer'
    end

    scenario 'tries to delete his own answer' do
      sign_in(answer.user)

      visit question_path(answer.question)

      expect(page).to have_content answer.body

      click_on 'Delete answer'
      expect(current_path).to eq(question_path(answer.question))
      expect(page).to_not have_content answer.body
    end
  end

  scenario 'Unauthenticated user tries to delete the answer' do
    visit question_path(answer.question)

    expect(page).to_not have_link 'Delete answer'
  end
end
