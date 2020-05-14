import apiClient from "./apiClient";
import $ from 'jquery';
import { renderGame } from "./gameRenderer";

const params = new URLSearchParams(window.location.search)

function getGame(gameId = null) {
  if (!!gameId) {
    apiClient.game.get(gameId, (res, status) => {
      if (status == 'error' && res.status == 404) { return }
      if (status == 'error' && res.status == 401) { return }

      renderGame(res.responseJSON.data, gameId)
    });
  } else {
    apiClient.game.getCurrent((res, status) => {
      if (status == 'error' && res.status == 404) {
        return;
      }

      renderGame(res.responseJSON.data, 'current')
    });
  }
}

$(document).ready(() => {
  getGame(params.get('game_id'));
});