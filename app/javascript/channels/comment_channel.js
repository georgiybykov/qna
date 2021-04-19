import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    console.log(gon.params)
    console.log(gon.user_id)

    this.perform('follow', { question_id: gon.params['id'] })
  },

  received(data) {
    console.log(gon.params)
    console.log(gon.user_id)
    console.log(data)
    console.log(data.user_id)
    console.log(data.comment.commentable_type === 'Question')

    if (!(gon.user_id === data.comment.user_id)) {
      let commentTemplate = require('templates/comment.hbs')({ comment: data.comment })

      if (data.comment.commentable_type === 'Question') {
        $('.question-comments').append(commentTemplate)
      } else {
        $('.answer-comments').append(commentTemplate)
      }
    }
  }
});
