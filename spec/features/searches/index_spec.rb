# frozen_string_literal: true

feature 'The user can search between resources by the query', %q{
  In order to find appropriate information
  As an authenticated user or a guest
  I would like to be able to type a unique query and make a search
}, type: :feature, aggregate_failures: true do

  describe 'Authenticated user can search' do
    background do
      sign_in(user)

      visit root_path
    end

    it_behaves_like 'searchable'
  end

  describe 'Guest of the resource can search' do
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
