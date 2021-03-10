$(document).on('turbolinks:load', function() {
    $('.answers').on('click', '.edit-answer-link', function(event) {
        event.preventDefault()
        let answerId = $(this).data('answerId')

        $('form#edit-answer-' + answerId).toggleClass('hidden')
    })
})
