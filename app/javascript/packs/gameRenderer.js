import apiClient from "./apiClient";
import $ from 'jquery';

let playingGameId;

function renderBoard(data) {
  $('#board').empty();

  const cols = data.attributes.columns;
  const rows = data.attributes.rows;
  const display = data.attributes.display.toLowerCase().split('');

  let r = 0;
  let c = 0;
  let statusClass;
  let value;

  while (r < rows) {
    c = 0;
    $('#board').append(`<div id="row-${r}" class="row"></div>`);

    while (c < cols) {
      value = display[(r * cols) + c]
      statusClass = `status-${value}`

      // Don't show values in this cases
      if (['h', 'f', 'm', '0'].includes(value)) {
        value = '';
      }

      $('#board').find(`#row-${r}`)
        .append(`<button class="cell active ${statusClass}" data-x="${r}" data-y="${c}" oncontextmenu="return false;">${value}</button>`);
      c += 1;
    }
    r += 1;
  }

  $('#board').find('.cell').on('click', e => {
    e.stopPropagation();

    if ($(e.target).hasClass('status-h') || $(e.target).hasClass('status-f')) {
      const data = $(e.target).data();
      performAction(data.x, data.y, 'reveal');
    }
  });

  $('#board').find('.cell').mousedown((e) => {
    e.stopPropagation();
    if (e.which == 3) {
      const data = $(e.target).data();
      if ($(e.target).hasClass('status-f')) {
        performAction(data.x, data.y, 'unflag');
      } else {
        performAction(data.x, data.y, 'flag');
      }
    }
  });
}

function renderResult(over, winner) {
  $('#result').empty();

  if (over) {
    $('#window-result').css({ display: "block" });

    if (winner) {
      $('#result').append('<h3>YOU WIN!</h3>');
      $('#result').append('<img src="https://media.giphy.com/media/12yZ3KEf43DfLG/giphy.gif"></img>');
    } else {
      $('#result').append('<h3>YOU LOSE</h3>');
      $('#result').append('<img src="https://media.giphy.com/media/1T96TRBBGYThC/giphy.gif"></img>');
    }  
  } else {
    $('#window-result').css({ display: "none" });
  }
}

function renderGame(data, gameId) {
  playingGameId = gameId || playingGameId;
  console.log(gameId, playingGameId)
  renderResult(data.attributes.over, data.attributes.winner);
  renderBoard(data);
}

function performAction(x, y, action) {
  apiClient.game[action](playingGameId, x, y, (res, status) => {
    renderGame(res.responseJSON.data)
  });
}

export { renderGame, renderBoard, renderResult }