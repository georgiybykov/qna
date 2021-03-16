# frozen_string_literal: true

feature 'The user can attach the files to the question', %q{
  In order to have visualized view
  As an authenticated user
  I would like to be able to attach the files to the question
}, type: :feature, js: true, aggregate_failures: true do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question_with_file) { create(:question, :with_file, user: author) }
  given(:filename) { question_with_file.files[0].filename.to_s }

  describe 'Authenticated author' do
    background do
      sign_in(author)
      visit questions_path
    end

    scenario 'creates the question with the attached files' do
      click_on 'Ask question'

      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Text in the question body'

      expect(page).to_not have_link 'first_file.txt'
      expect(page).to_not have_link 'second_file.txt'

      attach_file 'Files', ["#{Rails.root}/spec/fixtures/first_file.txt",
                            "#{Rails.root}/spec/fixtures/second_file.txt"]

      click_on 'Ask'

      expect(page).to have_content 'Your question has been successfully created!'
      expect(page).to have_content 'Question title'
      expect(page).to have_content 'Text in the question body'

      expect(page).to have_link 'first_file.txt'
      expect(page).to have_link 'second_file.txt'
    end

    scenario 'deletes the attached files from the question' do
      expect(page).to have_link filename

      within('.attachments') { click_on 'Delete file' }

      expect(page).to_not have_link filename
    end
  end

  scenario 'Authenticated user tries to delete the attached files from the question' do
    sign_in(user)

    visit questions_path

    expect(page).to have_link filename
    expect(page).to_not have_link 'Delete file'
  end

  scenario 'Unauthenticated user tries to delete the attached files from the question' do
    visit questions_path

    expect(page).to have_link filename
    expect(page).to_not have_link 'Delete file'
  end
end
