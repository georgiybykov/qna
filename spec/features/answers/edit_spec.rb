# frozen_string_literal: true

feature 'The user can edit the answer', %q{
  In order to correct the mistakes
  As an author of the answer
  I would like to be able to edit my answer
}, type: :feature, js: true, aggregate_failures: true do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated owner of the answer' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits hiw own answer' do
      click_on 'Edit'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        find("#answer_body-#{answer.id}").fill_in(with: 'Edited answer to the question')
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer to the question'
      end
    end

    scenario 'tries to edit the answer of another user' do
      click_on 'Edit'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        find("#answer_body-#{answer.id}").fill_in(with: '')
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content 'Body can\'t be blank'
      end
    end
  end

  describe 'Authenticated user who does not own the answer' do
    given!(:other_user) { create(:user) }

    scenario 'tries to edit the answer of another user' do
      sign_in(other_user)
      visit question_path(question)

      expect(current_path).to eq question_path(question)
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unauthenticated user tries to edit the answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
