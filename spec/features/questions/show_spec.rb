# frozen_string_literal: true

feature 'The user can see the list of the questions', %q{
  In order to choose the question to answer for
  or read another answers for questions
  As an authenticated user
  I would like to be able to see the list of the available questions
}, type: :feature, js: true, aggregate_failures: true do

  given(:question) { create(:question) }
  given!(:question_answers) { create_list(:answer, 3, question: question) }

  scenario 'The main page with questions to choose consists of the table with columns' do
    visit questions_path

    expect(page).to have_content 'Title'
    expect(page).to have_content 'Body'
    expect(page).to have_content 'Answers'
    expect(page).to have_content 'Files'
    expect(page).to have_content 'Links'
    expect(page).to have_content 'Comments'
    expect(page).to have_content 'Actions'
  end

  scenario 'The user looks at the list of the questions, selects first one and gets the list of answers ' do
    visit questions_path(question)

    expect(page).to have_content 'Questions'

    click_link 'Show'

    expect(page).to have_content question.body

    question_answers.each { |answer| expect(page).to have_content answer.body }
  end
end
