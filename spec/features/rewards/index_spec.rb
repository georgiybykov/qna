# frozen_string_literal: true

feature 'The user can see the list of the earned rewards', %q{
  In order to see the list of the achievements
  As an authenticated user
  I would like to be able to see the list of my rewards
}, type: :feature, aggregate_failures: true do

  given(:user) { create(:user) }
  given(:question) { create(:question, :with_reward, user: user) }
  given!(:user_rewards) { create_list(:reward, 3, user: user) }

  scenario 'Authenticated user can see the list of his rewards' do
    sign_in(user)

    visit rewards_path

    user_rewards.each do |reward|
      expect(page).to have_content reward.question.title
      expect(page).to have_content reward.title
    end
  end
end
