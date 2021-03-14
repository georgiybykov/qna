# frozen_string_literal: true

feature 'The user can answer the question', %q{
  In order to start a discussion about the question
  As an authenticated user
  I would like to be able to answer the question
}, type: :feature, js: true, aggregate_failures: true do

  given(:question) { create(:question) }

  describe 'Authenticated user creates the answer' do
    given(:user) { create(:user) }

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

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create answer'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        expect(page).to have_content 'Answer to the question'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'with invalid data (with the empty answer body)' do
      fill_in 'Your answer', with: ''
      click_on 'Create answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  scenario 'Unauthenticated user tries to create the answer' do
    visit question_path(question)

    expect(page).to_not have_button 'Create Answer'
  end
end
