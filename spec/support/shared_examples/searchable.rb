# frozen_string_literal: true

shared_examples 'searchable' do
  given(:search_query) { 'search-query' }

  scenario 'between all resources' do # rubocop:disable RSpec/ExampleLength
    within '.search' do
      fill_in 'Search query', with: search_query
      select 'All scopes', from: :search_scope
      click_on 'Search'
    end

    expect(page).to have_content 'Author of the question:'
    expect(page).to have_content 'search-query-question'

    expect(page).to have_content 'Author of the answer:'
    expect(page).to have_content 'search-query-answer'

    expect(page).to have_content 'Comment body: search-query-comment'

    expect(page).to have_content "The user with email: #{user.email}"
  end

  scenario 'between questions' do
    within '.search' do
      fill_in 'Search query', with: search_query
      select 'Question', from: :search_scope
      click_on 'Search'
    end

    expect(page).to have_content 'Author of the question:'
    expect(page).to have_content 'search-query-question'
  end

  scenario 'between answers' do
    within '.search' do
      fill_in 'Search query', with: search_query
      select 'Answer', from: :search_scope
      click_on 'Search'
    end

    expect(page).to have_content 'Author of the answer:'
    expect(page).to have_content 'search-query-answer'
  end

  scenario 'between comments' do
    within '.search' do
      fill_in 'Search query', with: search_query
      select 'Comment', from: :search_scope
      click_on 'Search'
    end

    expect(page).to have_content 'Author of the answer:'
    expect(page).to have_content 'Comment body: search-query-comment'
  end

  scenario 'between users' do
    within '.search' do
      fill_in 'Search query', with: search_query
      select 'User', from: :search_scope
      click_on 'Search'
    end

    expect(page).to have_content "The user with email: #{user.email}"
  end
end
