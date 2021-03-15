# frozen_string_literal: true

feature 'The user can edit the answer', %q{
  In order to correct the mistakes
  As an author of the answer
  I would like to be able to edit my answer
}, type: :feature, js: true, aggregate_failures: true do

  given(:author) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated owner of the answer' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'edits his answer with valid data' do
      click_on 'Edit'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        find("#answer_body-#{answer.id}").fill_in(with: 'Edited answer to the question')
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer to the question'
      end
    end

    scenario 'edits his answer with invalid data' do
      click_on 'Edit'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        find("#answer_body-#{answer.id}").fill_in(with: '')
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content 'Body can\'t be blank'
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'attaches the files to the answer during editing' do
      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to_not have_link 'spec_helper.rb'

      within '.answers' do
        click_on 'Edit'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  describe 'Authenticated user who does not own the answer' do
    given!(:user) { create(:user) }

    scenario 'tries to edit the answer of another user' do
      sign_in(user)
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
