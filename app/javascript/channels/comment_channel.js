import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    this.perform('follow', { question_id: gon.params['id'] })
  },

  received(data) {
    if (!(gon.user_id === data.comment.user_id)) {
      let commentTemplate = require('templates/comment.hbs')({ comment: data.comment })
      let commentable = data.comment.commentable_type.toLowerCase()

      $('#' + commentable + '_' + data.comment.commentable_id + ' .' + commentable + '-comments')
          .append(commentTemplate)
    }
  }
});
