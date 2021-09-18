# frozen_string_literal: true

feature 'The user can search between resources by the query', %q{
  In order to find appropriate information
  As an authenticated user or a guest
  I would like to be able to type a unique query and make a search
}, type: :feature, aggregate_failures: true do

  given(:question) { create(:question, body: 'search-query-question', user: user) }
  given(:answer) { create(:answer, body: 'search-query-answer', question: question, user: user) }
  given!(:comment) { create(:comment, body: 'search-query-comment', commentable: answer, user: user) }
  given(:user) { create(:user, email: 'search-query-user@test.com') }

  background do
    Question.__elasticsearch__.refresh_index!
    Answer.__elasticsearch__.refresh_index!
    Comment.__elasticsearch__.refresh_index!
    User.__elasticsearch__.refresh_index!
  end

  describe 'Authenticated user can search', :elasticsearch do
    background do
      sign_in(user)

      visit root_path
    end

    it_behaves_like 'searchable'
  end

  describe 'Guest of the resource can search', :elasticsearch do
    background { visit root_path }

    it_behaves_like 'searchable'
  end

  describe 'when search params are invalid' do
    background { visit root_path }

    scenario 'and the query is nil or empty' do
      within '.search' do
        fill_in 'Search query', with: nil
        select 'All scopes', from: :search_scope
        click_on 'Search'
      end

      expect(page).to have_content "Query can't be blank"
    end

    scenario 'and the query is too short' do
      within '.search' do
        fill_in 'Search query', with: 'xx'
        select 'All scopes', from: :search_scope
        click_on 'Search'
      end

      expect(page).to have_content 'Query is too short (minimum is 3 characters)'
    end
  end
end
