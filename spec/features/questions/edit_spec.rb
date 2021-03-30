# frozen_string_literal: true

feature 'The user can edit the question', %q{
  In order to put some updates or correct mistakes
  As an author of the question
  I would like to be able to edit my question
}, type: :feature, js: true, aggregate_failures: true do

  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:url) { 'https://www.example.com/' }

  describe 'Authenticated owner of the question' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'edits his question with valid data' do
      within '.single-question' do
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
      within '.single-question' do
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
      expect(page).to_not have_link 'first_file.txt'
      expect(page).to_not have_link 'second_file.txt'

      within '.single-question' do
        click_on 'Edit'

        attach_file 'Files', ["#{Rails.root}/spec/fixtures/first_file.txt",
                              "#{Rails.root}/spec/fixtures/second_file.txt"]

        click_on 'Save'

        expect(page).to have_link 'first_file.txt'
        expect(page).to have_link 'second_file.txt'
      end
    end

    scenario 'adds a link to the question during editing' do
      within '.single-question' do
        click_on 'Edit'

        click_on 'Add link'

        fill_in 'Link name', with: 'New Link'
        fill_in 'URL', with: url

        click_on 'Save'

        expect(page).to have_link 'New Link', href: url
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
