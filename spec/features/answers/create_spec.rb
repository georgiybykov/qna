# frozen_string_literal: true

feature 'The user can answer the question', %q{
  In order to start a discussion about the question
  As an authenticated user
  I would like to be able to answer the question
}, type: :feature, js: true, aggregate_failures: true do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user creates the answer' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with valid data' do
      fill_in 'Your answer', with: 'Answer to the question'
      click_on 'Create answer'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        expect(page).to have_content 'Answer to the question'
      end
    end

    scenario 'with attached files' do
      fill_in 'Your answer', with: 'Answer to the question'

      expect(page).not_to have_link 'first_file.txt'
      expect(page).not_to have_link 'second_file.txt'

      attach_file 'Add files', ["#{Rails.root}/spec/fixtures/first_file.txt",
                                "#{Rails.root}/spec/fixtures/second_file.txt"]

      click_on 'Create answer'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        expect(page).to have_content 'Answer to the question'

        expect(page).to have_link 'first_file.txt'
        expect(page).to have_link 'second_file.txt'
      end
    end

    scenario 'with invalid data (with the empty answer body)' do
      fill_in 'Your answer', with: ''
      click_on 'Create answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  describe 'Multiple sessions', js: true do
    given(:url) { 'https://first-example.com/new' }

    scenario 'with the answer appears on another page of the user' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'Answer to the question'

        fill_in 'Link name', with: 'Valid Link'
        fill_in 'URL', with: url

        click_on 'Create answer'

        within '.answers' do
          expect(page).to have_content 'Answer to the question'
        end

        within "#answer_#{question.answers.first.id}" do
          expect(page).to have_link 'Valid Link', href: url
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Answer to the question'
        end

        within "#answer_#{question.answers.first.id}" do
          expect(page).to have_link 'Valid Link', href: url
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to create the answer' do
    visit question_path(question)

    expect(page).not_to have_button 'Create Answer'
  end
end
