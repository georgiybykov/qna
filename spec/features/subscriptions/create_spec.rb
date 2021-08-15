# frozen_string_literal: true

feature 'The user can subscribe to the question updates', %q{
  In order to receive notifications about new answers for the question
  As an authenticated user
  I would like to be able to subscribe to the question updates
}, type: :feature, aggregate_failures: true, js: true do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'tries to subscribe to the question updates' do
      visit question_path(question)

      within('.subscription') do
        expect(page).to have_link 'Subscribe'

        click_on 'Subscribe'

        expect(page).not_to have_link 'Subscribe'
      end
    end

    context 'with the current subscription' do
      background { create(:subscription, question: question, user: user) }

      scenario 'tries to subscribe to the question updates' do
        visit question_path(question)

        expect(page).not_to have_link 'Subscribe'
      end
    end
  end

  scenario 'Unauthenticated user tries to subscribe to the question updates' do
    visit question_path(question)

    expect(page).not_to have_link 'Subscribe'
  end
end
