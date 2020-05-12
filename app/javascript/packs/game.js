import $ from 'jquery';

console.log($('#board'));

$.ajax({
  type: "POST",
  url: 'http://localhost:3000/api/v1/games',
  data: {},
  success: (res) => {
    console.log(res);

    const cols = res.data.attributes.columns;
    const rows = res.data.attributes.rows;
    const display = res.data.attributes.display.toLowerCase().split('');

    let r = 0;
    let c = 0;
    let statusClass;

    while (r < rows) {
      c = 0;
      $('#board').append(`<div id="row-${r}" class="row"></div>`);

      while (c < cols) {
        statusClass = `status-${display[(r * cols) + c]}`
        $('#board').find(`#row-${r}`)
          .append(`<button class="cell ${statusClass}" data-x="${r}" data-y="${c}"></button>`);
        c += 1;
      }
      r += 1;
    }

    $('#board').find('.cell').on('click', e => {
      e.stopPropagation();

      console.log($(e.target).data())

      if ($(e.target).hasClass('status-h') || $(e.target).hasClass('status-f')) {
        $(e.target).parents('li').first().remove();
      }
    });

  },
  dataType: 'json'
});