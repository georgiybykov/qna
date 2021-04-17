import consumer from "./consumer"

consumer.subscriptions.create("AnswersChannel", {
  connected() {
    this.perform('follow', { question_id: gon.params['id'] })
  },

  received(data) {
    console.log(data)

    if (!(gon.user_id === data.user_id)) {
      let answerTemplate = require('templates/answer.hbs')({
        answer: data.answer,
        links: data.links,
        rating: data.rating
      })

      $('.answers').append(answerTemplate)
    }
  }
});
