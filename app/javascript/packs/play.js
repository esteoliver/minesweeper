import apiClient from "./apiClient";
import $ from 'jquery';
import { renderGame } from "./gameRenderer";

const params = new URLSearchParams(window.location.search)

function newGame() {
  apiClient.game.create({}, (res, status) => {
    if (status == 'error') { return }
    
    renderGame(res.responseJSON.data);

    // change url with new game id
    params.set('game_id', res.responseJSON.data.id)
    let url = new URL(window.location.href);
    url.search = params;
    url = url.toString();
    window.history.replaceState({url: url}, null, url);
  })
}

function getGame(gameId = null) {
  if (!!gameId) {
    apiClient.game.get(gameId, (res, status) => {
      if (status == 'error' && res.status == 404) { return }
      if (status == 'error' && res.status == 401) { return }

      renderGame(res.responseJSON.data)
    });
  } else {
    if (!!params.get('new')) {
      newGame();
    } else {
      apiClient.game.getCurrent((res, status) => {
        if (status == 'error' && res.status == 404) {
          newGame(); // in case of anonymous player
        }

        renderGame(res.responseJSON.data)
      });  
    }
  }
}

$(document).ready(() => {
  $('#new-game').on('click', e => {
    e.stopPropagation();
    newGame();
  });

  getGame(params.get('game_id'));
});