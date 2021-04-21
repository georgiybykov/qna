# frozen_string_literal: true

feature 'The user can vote for the question', %q{
  In order to mark the question as liked
  As an authenticated user
  I would like to be able to vote
}, type: :feature, js: true, aggregate_failures: true do

  given(:author) { create(:user) }
  given(:voter) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authenticated user (not the author of the question)' do
    background do
      sign_in(voter)
      visit question_path(question)
    end

    scenario 'tries to vote up for the question' do
      within "#question_#{question.id}" do
        click_on '+'

        within '.resource-rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'tries to vote up for the question twice' do
      within "#question_#{question.id}" do
        click_on '+'
        click_on '+'

        within '.resource-rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'revokes his vote' do
      within "#question_#{question.id}" do
        click_on '+'
        click_on 'Revoke vote'

        within '.resource-rating' do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'votes down for question' do
      within "#question_#{question.id}" do
        click_on '-'

        within '.resource-rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'tries to vote down for the question twice' do
      within "#question_#{question.id}" do
        click_on '-'
        click_on '-'

        within '.resource-rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'tries to do re-vote for the question' do
      within "#question_#{question.id}" do
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
    background { visit question_path(question) }

    scenario 'vote up for the question' do
      expect(page).to_not have_selector '.vote'

      expect(page).to_not have_link 'Revoke vote'
    end

    scenario 'vote down for the question' do
      expect(page).to_not have_selector '.vote'

      expect(page).to_not have_link 'Revoke vote'
    end

    scenario 'revoke the vote from the question' do
      expect(page).to_not have_selector '.vote'

      expect(page).to_not have_link 'Revoke vote'
    end
  end
end
