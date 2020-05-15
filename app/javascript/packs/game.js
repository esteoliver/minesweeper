import apiClient from "./apiClient";
import $ from 'jquery';

function newGame() {
  apiClient.game.create(game, (res, status) => {
    if (status == 'error') { 
      $('#message').empty();
      $('#message').text(res.responseJSON.errors[0].detail)
      return;
    }
    
    window.location.href = `/play?game_id=${res.responseJSON.data.id}`;
  })
}

const game = { level: 'intermediate' };

$(document).ready(() => {
  $('input').on('change', e => {
    const input = $(e.target);
    game[input.attr('name')] = input.val();
  });

  $('input[type=radio]').on('change', e => {
    const input = $(e.target);

    if (input.attr('id') == 'custom') {
      $('input[type=number]').prop('disabled', false)
    } else {
      $('input[type=number]').prop('disabled', true)
    }
  })

  $('#new-game').on('click', e => {
    e.stopPropagation();
    newGame();
  });
});