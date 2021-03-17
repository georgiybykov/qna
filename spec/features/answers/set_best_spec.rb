# frozen_string_literal: true

feature 'The user can select the best answer for his question', %q{
  In order to choose more appropriate answer
  As an authenticated user
  I would like to be able to mark the only one question as the best
}, type: :feature, js: true, aggregate_failures: true do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:answers) { create_list(:answer, 4, question: question, user: author) }

  describe 'Authenticated user' do
    background do
      sign_in(author)
      visit question_path(answer.question)
    end

    scenario 'sets the best answer' do
      within "#answer_#{answer.id}" do
        expect(page).not_to have_content 'BEST'

        click_on 'Mark as best'

        expect(page).to have_content 'BEST'
      end
    end

    scenario 'sets a new answer as best' do
      within "div#answer_#{answers[-1].id}" do
        click_on 'Mark as best'
      end

      within "div#answer_#{answers[0].id}" do
        click_on 'Mark as best'

        expect(page).to_not have_content 'Mark as best'
        expect(page).to have_content 'BEST'
      end
    end
  end

  scenario 'The authenticated user tries to set the best answer of for the question of the other user' do
    sign_in(user)
    visit question_path(answer.question)

    expect(page).to_not have_link 'Mark as best'
  end

  scenario 'Unauthenticated user tries to set the best answer' do
    visit question_path(answer.question)

    expect(page).to_not have_link 'Mark as best'
  end
end
