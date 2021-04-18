# frozen_string_literal: true

feature 'The user can leave a comment for the question or the answer', %q{
  In order to share self opinion
  As an authenticated user
  I'd like to write a comment for the question ot the answer
}, type: :feature, js: true, aggregate_failures: true do

  given(:user) { create :user }
  given(:question) { create :question, user: user }

  describe 'Authenticated user tries to leave a comment for the question' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with valid data' do
      fill_in 'Your comment', with: 'Test comment'
      click_on 'Create comment'

      expect(page).to have_content 'Test comment'
    end

    scenario 'with invalid data' do
      click_on 'Create comment'

      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  scenario 'Unauthenticated user tries to leave a comment for the question' do
    visit question_path(question)

    expect(page).to_not have_selector '.new-comment'
  end
end
