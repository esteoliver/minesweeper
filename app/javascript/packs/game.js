import apiClient from "./apiClient";
import $ from 'jquery';
import { renderGame } from "./gameRenderer";

function newGame() {
  apiClient.game.create({}, (res, status) => {
    if (status == 'error') { return }
    
    renderGame(res.responseJSON.data);
  })
}

function getGame(reset = null) {
  apiClient.game.getCurrent((res, status) => {
    if (status == 'error' && res.status == 404) {
      newGame();
    } else {
      renderGame(res.responseJSON.data)
    }
  })
}

$(document).ready(() => {
  $('#new-game').on('click', e => {
    e.stopPropagation();
    newGame();
  });

  getGame();
});