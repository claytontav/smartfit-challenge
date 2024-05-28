import consumer from "channels/consumer"

consumer.subscriptions.create("PageChannel", {
  connected() {
    
  },

  disconnected() {
    
  },

  received(data) {
    
  }
});
