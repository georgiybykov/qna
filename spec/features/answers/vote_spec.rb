# frozen_string_literal: true

feature 'The user can vote for the answer', %q{
  In order to mark the answer as liked
  As an authenticated user
  I would like to be able to vote
}, type: :feature, js: true, aggregate_failures: true do

  given(:author) { create(:user) }
  given(:voter) { create(:user) }
  given(:answer) { create(:answer, user: author) }

  describe 'Authenticated user (not the author of the answer)' do
    background do
      sign_in(voter)
      visit question_path(answer.question)
    end

    scenario 'tries to vote up for the answer' do
      within "#answer_#{answer.id}" do
        click_on '+'

        within '.resource-rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'tries to vote up for the answer twice' do
      within "#answer_#{answer.id}" do
        click_on '+'
        click_on '+'

        within '.resource-rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'revokes his vote' do
      within "#answer_#{answer.id}" do
        click_on '+'
        click_on 'Revoke vote'

        within '.resource-rating' do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'votes down for answer' do
      within "#answer_#{answer.id}" do
        click_on '-'

        within '.resource-rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'tries to vote down for the answer twice' do
      within "#answer_#{answer.id}" do
        click_on '-'
        click_on '-'

        within '.resource-rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'tries to do re-vote for the answer' do
      within "#answer_#{answer.id}" do
        click_on "+"

        within '.resource-rating' do
          expect(page).to have_content '1'
        end

        click_on 'Revoke vote'
        click_on '-'

        within '.resource-rating' do
          expect(page).to have_content '-1'
        end
      end
    end
  end

  describe 'Unauthorized user tries to' do
    background { visit question_path(answer.question) }

    scenario 'vote up for the answer' do
      expect(page).to_not have_selector '.vote'

      expect(page).to_not have_link 'Revoke vote'
    end

    scenario 'vote down for the answer' do
      expect(page).to_not have_selector '.vote'

      expect(page).to_not have_link 'Revoke vote'
    end

    scenario 'revoke the vote from the answer' do
      expect(page).to_not have_selector '.vote'

      expect(page).to_not have_link 'Revoke vote'
    end
  end
end
