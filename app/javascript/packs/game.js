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
      if (value == 'h' || value == 'f' || value == '0') {
        value = ''
      } 

      $('#board').find(`#row-${r}`)
        .append(`<button class="cell active ${statusClass}" data-x="${r}" data-y="${c}">${value}</button>`);
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
}

function performAction(x,y, action) {
  $.ajax({
    type: "POST",
    url: 'http://localhost:3000/api/v1/player_actions',
    data: {
      player_action: { x, y, action }
    },
    success: renderGame,
    dataType: 'json'
  });
}

function getGame() {
  $.ajax({
    type: "POST",
    url: 'http://localhost:3000/api/v1/games',
    data: {},
    success: renderGame,
    dataType: 'json'
  });
}

getGame();

