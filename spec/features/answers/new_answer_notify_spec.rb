# frozen_string_literal: true

feature 'Subscribed user can receive notifications', %q{
  In order to have updates about the question
  As an authenticated user
  I would like to be able to receive notifications about new answers
}, type: :feature, js: true, aggregate_failures: true do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Multiple sessions', :sidekiq_inline do
    # before { Sidekiq::Testing.inline! }

    context 'when author of the question' do
      scenario 'receives notifications about new answers' do
        Capybara.using_session('author') do
          sign_in(author)
          visit question_path(question)
        end

        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)

          fill_in 'Your answer', with: 'Answer to the question'
          click_on 'Create answer'

          expect(page).to have_content 'Answer to the question'
        end

        Capybara.using_session('author') do
          open_email(author.email)

          expect(current_email)
            .to have_content "The user #{user.email} created a new answer for the question #{question.title}:"
        end
      end

      scenario 'has been unsubscribed and does not receive notifications about new answers' do
        Capybara.using_session('author') do
          sign_in(author)
          visit question_path(question)

          within('.subscription') do
            click_on 'Unsubscribe'
          end
        end

        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)

          fill_in 'Your answer', with: 'Answer to the question'
          click_on 'Create answer'

          expect(page).to have_content 'Answer to the question'
        end

        Capybara.using_session('author') do
          open_email(author.email)

          expect(current_email)
            .to_not have_content "The user #{user.email} created a new answer for the question #{question.title}:"
        end
      end
    end

    context 'when another user' do
      scenario 'has been subscribed and receives notifications about new answers' do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)

          click_on 'Subscribe'
        end

        Capybara.using_session('author') do
          sign_in(author)
          visit question_path(question)

          fill_in 'Your answer', with: 'Answer to the question'
          click_on 'Create answer'

          expect(page).to have_content 'Answer to the question'
        end

        Capybara.using_session('user') do
          open_email(user.email)

          expect(current_email)
            .to have_content "The user #{author.email} created a new answer for the question #{question.title}:"
        end
      end

      scenario 'has been unsubscribed and does not receive notifications about new answers' do
        create(:subscription) { create(:subscription, question: question, user: user) }

        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)

          click_on 'Unsubscribe'
        end

        Capybara.using_session('author') do
          sign_in(author)
          visit question_path(question)

          fill_in 'Your answer', with: 'Answer to the question'
          click_on 'Create answer'

          expect(page).to have_content 'Answer to the question'
        end

        Capybara.using_session('user') do
          open_email(user.email)

          expect(current_email)
            .to_not have_content "The user #{author.email} created a new answer for the question #{question.title}:"
        end
      end
    end

    context 'when guest of the resource' do
      scenario 'does not have an ability to subscribe and receive notifications' do
        Capybara.using_session('guest') do
          visit question_path(question)

          expect(page).not_to have_link 'Subscribe'
        end
      end
    end

    # after { Sidekiq::Testing.disable! }
  end
end
