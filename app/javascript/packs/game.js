import $ from 'jquery';

function renderGame(res) {
  $('#board').empty();

  const cols = res.data.attributes.columns;
  const rows = res.data.attributes.rows;
  const display = res.data.attributes.display.toLowerCase().split('');

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

function performAction(x, y, action) {
  $.ajax({
    type: "POST",
    url: 'http://localhost:3000/api/v1/player_actions',
    data: {
      player_action: {
        x,
        y,
        action
      }
    },
    success: renderGame,
    dataType: 'json'
  });
}

function getGame(reset = null) {
  $.ajax({
    type: "POST",
    url: 'http://localhost:3000/api/v1/games',
    data: {
      new: reset
    },
    success: renderGame,
    dataType: 'json'
  });
}

$(document).ready(() => {
  $('#new-game').on('click', e => {
    e.stopPropagation();
    getGame(true);
  });

  getGame();
});