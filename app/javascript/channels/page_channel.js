import consumer from "channels/consumer"

consumer.subscriptions.create("PageChannel", {
  connected() {
    console.log("Connect ...")
  },

  disconnected() {
    console.log("Desconnect ...")
  },

  received(data) {
    console.log(data)
  }
});
