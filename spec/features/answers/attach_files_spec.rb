# frozen_string_literal: true

feature 'The user can attach the files to the answer', %q{
  In order to have visualized view
  As an authenticated user
  I would like to be able to attach the files to the answer
}, type: :feature, js: true, aggregate_failures: true do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer_with_file) { create(:answer, :with_file, user: author) }
  given(:filename) { answer_with_file.files[0].filename.to_s }

  describe 'Authenticated author' do
    background { sign_in(author) }

    scenario 'creates the answer with the attached files' do
      visit question_path(question)

      fill_in 'Your answer', with: 'Answer to the question'

      expect(page).not_to have_link 'first_file.txt'
      expect(page).not_to have_link 'second_file.txt'

      attach_file 'Add files', ["#{Rails.root}/spec/fixtures/first_file.txt",
                                "#{Rails.root}/spec/fixtures/second_file.txt"]

      click_on 'Create answer'

      expect(page).to have_content 'Answer to the question'

      expect(page).to have_link 'first_file.txt'
      expect(page).to have_link 'second_file.txt'
    end

    scenario 'deletes the attached files from the answer' do
      visit question_path(answer_with_file.question)

      expect(page).to have_link filename

      within('.attachments') { click_on 'Delete file' }

      expect(page).not_to have_link filename
    end
  end

  scenario 'Authenticated user tries to delete the attached files from the answer' do
    sign_in(user)

    visit question_path(answer_with_file.question)

    expect(page).to have_link filename
    expect(page).not_to have_link 'Delete file'
  end

  scenario 'Unauthenticated user tries to delete the attached files from the answer' do
    visit question_path(answer_with_file.question)

    expect(page).to have_link filename
    expect(page).not_to have_link 'Delete file'
  end
end
