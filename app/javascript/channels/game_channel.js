import consumer from "./consumer"

document.addEventListener('turbo:load', () => {
  const element = document.getElementById('game-id');
  if (!element) return;
  const game_id = element.getAttribute('data-game-id');

  consumer.subscriptions.create({channel: "GameChannel", game_id: game_id}, {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      if (data.type === 'players') {
        const el = document.getElementById('players_table');
        if (el) el.innerHTML = data.html;
      } else if (data.type === 'stories') {
        const el = document.getElementById('stories_panel');
        if (el) el.innerHTML = data.html;
      }
    }
  });
})


