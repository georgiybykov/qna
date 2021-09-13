# frozen_string_literal: true

shared_examples 'searchable' do
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer) }
  given(:comment) { create(:comment, commentable: question, user: user) }
  given(:user) { create(:user, email: 'questions-author@test.com') }

  given(:search) { build(:search) }

  # rubocop:disable RSpec/ExampleLength
  scenario 'between all resources' do
    search = build(:search, query: 'QuestionTitle', scope: 'All scopes')

    expect(ThinkingSphinx)
      .to receive(:search)
            .with(search.query, classes: [nil])
            .and_return([question, answer, comment, user])
            .once

    within '.search' do
      fill_in 'Search query', with: search.query
      select search.scope, from: :search_scope
      click_on 'Search'
    end

    expect(page).to have_content 'Author of the question:'
    expect(page).to have_content 'QuestionBody'

    expect(page).to have_content 'Author of the answer:'
    expect(page).to have_content 'AnswerBody'

    expect(page).to have_content 'Comment body: MyText'

    expect(page).to have_content "The user with email: #{user.email}"
  end

  scenario 'between questions' do
    search = build(:search, query: 'QuestionTitle', scope: 'Question')

    expect(ThinkingSphinx)
      .to receive(:search)
            .with(search.query, classes: [search.scope.classify.constantize])
            .and_return([question])
            .once

    within '.search' do
      fill_in 'Search query', with: search.query
      select search.scope, from: :search_scope
      click_on 'Search'
    end

    expect(page).to have_content 'Author of the question:'
    expect(page).to have_content 'QuestionBody'
  end

  scenario 'between answers' do
    search = build(:search, query: 'Body', scope: 'Answer')

    expect(ThinkingSphinx)
      .to receive(:search)
            .with(search.query, classes: [search.scope.classify.constantize])
            .and_return([answer])
            .once

    within '.search' do
      fill_in 'Search query', with: search.query
      select search.scope, from: :search_scope
      click_on 'Search'
    end

    expect(page).to have_content 'Author of the answer:'
    expect(page).to have_content 'AnswerBody'
  end

  scenario 'between comments' do
    search = build(:search, query: 'Body', scope: 'Comment')

    expect(ThinkingSphinx)
      .to receive(:search)
            .with(search.query, classes: [search.scope.classify.constantize])
            .and_return([comment])
            .once

    within '.search' do
      fill_in 'Search query', with: search.query
      select search.scope, from: :search_scope
      click_on 'Search'
    end

    expect(page).to have_content 'Author of the question:'
    expect(page).to have_content 'Comment body: MyText'
  end

  scenario 'between users' do
    search = build(:search, query: 'author', scope: 'User')

    expect(ThinkingSphinx)
      .to receive(:search)
            .with(search.query, classes: [search.scope.classify.constantize])
            .and_return([user])
            .once

    within '.search' do
      fill_in 'Search query', with: search.query
      select search.scope, from: :search_scope
      click_on 'Search'
    end

    expect(page).to have_content "The user with email: #{user.email}"
  end
  # rubocop:enable RSpec/ExampleLength
end
