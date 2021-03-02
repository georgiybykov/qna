# frozen_string_literal: true

feature 'The user can answer the question', %q{
  In order to start a discussion about the question
  As an authenticated user
  I would like to be able to answer the question
}, type: :feature, aggregate_failures: true do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'Authenticated user tries to create the answer' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'Answer to the question'
    click_on 'Create Answer'

    expect(page).to have_content('Your answer has been successfully created!')
    expect(page).to have_content('Answer to the question')
  end

  scenario 'Unauthenticated user tries to create the answer' do
    visit question_path(question)

    expect(page).to_not have_button('Create Answer')
  end
end
