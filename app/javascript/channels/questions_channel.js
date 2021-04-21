import consumer from "./consumer"

consumer.subscriptions.create('QuestionsChannel', {
  connected() {
    this.perform('follow')
  },

  received(data) {
    $('.questions-list').append(data)
  }
});
