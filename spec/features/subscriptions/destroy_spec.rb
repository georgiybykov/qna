# frozen_string_literal: true

feature 'The user can unsubscribe from the question updates', %q{
  In order to not receive notifications about new answers for the question
  As an authenticated user
  I would like to be able to unsubscribe from the question updates
}, type: :feature, aggregate_failures: true, js: true do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    context 'with the current subscription' do
      background { create(:subscription, question: question, user: user) }

      scenario 'tries to unsubscribe from the question updates' do
        visit question_path(question)

        within('.subscription') do
          expect(page).to have_link 'Unsubscribe'
          expect(page).not_to have_link 'Subscribe'

          click_on 'Unsubscribe'

          expect(page).not_to have_link 'Unsubscribe'
          expect(page).to have_link 'Subscribe'
        end
      end
    end

    scenario 'tries to unsubscribe from the question updates' do
      visit question_path(question)

      within('.subscription') do
        expect(page).not_to have_link 'Unsubscribe'
      end
    end
  end

  scenario 'Unauthenticated user tries to unsubscribe from the question updates' do
    visit question_path(question)

    expect(page).not_to have_link 'Unsubscribe'
  end
end
