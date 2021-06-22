import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById('game-id');
  const game_id = element.getAttribute('data-game-id');
  console.log(game_id);

  consumer.subscriptions.create({channel: "GameChannel", game_id: game_id}, {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      console.log(data);
      const players_table = document.getElementById('players_table');
      players_table.innerHTML = data;
    }
  });
})


