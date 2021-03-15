# frozen_string_literal: true

feature 'The user can edit the question', %q{
  In order to put some updates or correct mistakes
  As an author of the question
  I would like to be able to edit my question
}, type: :feature, js: true, aggregate_failures: true do

  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Authenticated owner of the question' do
    background do
      sign_in(author)
      visit questions_path
    end

    scenario 'edits hiw question with valid data' do
      within '.questions' do
        click_on 'Edit'

        fill_in 'Title', with: 'Edited question title'
        fill_in 'Your question', with: 'Edited question body'

        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited question title'
        expect(page).to have_content 'Edited question body'
      end
    end

    scenario 'tries to edit hiw question with invalid data' do
      within '.questions' do
        click_on 'Edit'

        fill_in 'Title', with: ''
        fill_in 'Your question', with: ''

        click_on 'Save'

        expect(page).to have_content 'Title can\'t be blank'
        expect(page).to have_content 'Body can\'t be blank'
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'attaches the files to the question during editing' do
      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to_not have_link 'spec_helper.rb'

      within '.questions' do
        click_on 'Edit'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  describe 'Authenticated user who does not own the question' do
    given!(:user) { create(:user) }

    scenario 'tries to edit the question of another user' do
      sign_in(user)
      visit questions_path

      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unauthenticated user tries to edit the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
