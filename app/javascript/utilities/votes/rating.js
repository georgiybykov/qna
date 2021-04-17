$(document).on('turbolinks:load', function(){
    $('.vote').on('ajax:success', function(e) {
        let id = e.detail[0]['id'],
            name = e.detail[0]['name'],
            rating = e.detail[0]['rating'];

        let ratingText = '<b>Rating: <b>'

        $('#' + name + '_' + id + ' .resource-rating').html(ratingText + rating)
    })
})
