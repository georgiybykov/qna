# frozen_string_literal: true

feature 'The user can add a reward to the question', %q{
  In order to reward the author of the best answer
  As an author of the question
  I would like to be able to set a reward
}, type: :feature, aggregate_failures: true do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'Authenticated adds a reward when asks a question' do
    fill_in 'Title', with: 'New Question'
    fill_in 'Body', with: 'Text in the question body'

    within '.reward' do
      fill_in 'Reward', with: 'New Reward'

      attach_file 'Image', "#{Rails.root}/spec/fixtures/first_file.txt"
    end

    click_on 'Ask'

    expect(page).to have_content 'New Question'

    expect(user.reload.questions.last.reward.persisted?).to be_truthy
  end
end
