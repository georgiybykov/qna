# frozen_string_literal: true

feature 'The user can delete links to the answer', %q{
  In order to delete unnecessary information
  As an author of the answer
  I would like to be able to delete links
}, type: :feature, js: true, aggregate_failures: true do

  given(:first_user) { create(:user) }
  given(:second_user) { create(:user) }

  given(:question) { create(:question, user: first_user) }
  given(:answer) {create(:answer, question: question, user: second_user) }

  given!(:link) { create(:link, linkable: answer) }

  describe 'Authenticated user' do
    scenario 'and the author of the answer deletes link' do
      sign_in(second_user)
      visit question_path(question)

      within "#answer_#{answer.id}" do
        within "#link_#{link.id}" do
          expect(page).to have_link link.name, href: link.url

          click_on 'Delete link'
        end
      end

      expect(page).not_to have_link link.name, href: link.url
    end

    scenario 'and not an author of the answer tries to delete link' do
      sign_in(first_user)
      visit question_path(question)

      within "#answer_#{answer.id}" do
        expect(page).to have_link link.name, href: link.url
        expect(page).not_to have_content 'Delete link'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete the link for the answer' do
    visit question_path(question)

    within "#answer_#{answer.id}" do
      expect(page).to have_link link.name, href: link.url
      expect(page).not_to have_content 'Delete link'
    end
  end
end
