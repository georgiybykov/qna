$(document).on('turbolinks:load', function() {
    $('.single-question').on('click', '.edit-question-link', function(event) {
        event.preventDefault()
        let questionId = $(this).data('questionId')

        $('form#edit-question-' + questionId).toggleClass('hidden')
    })
})
