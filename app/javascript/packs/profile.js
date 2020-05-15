import apiClient from "./apiClient";
import $ from 'jquery';
import moment from "moment";

String.prototype.rjust = function( length, char ) {
  var fill = [];
  while ( fill.length + this.length < length ) {
    fill[fill.length] = char;
  }
  return fill.join('') + this;
}

function renderList(data) {
  $('#game-list').empty();

  data.forEach((game) => {
      
    let status;
    let action;
    let time;

    if (game.attributes.over) {
      if (game.attributes.winner) {
        status = '<b class="text-success">WIN</b>';
      } else {
        status = '<b class="text-danger">LOST</b>';
      }
      let duration = moment.duration(game.attributes.time * 1000);
      time = `<span>Time: ${duration.hours().toString().rjust(2, '0')}:${duration.minutes().toString().rjust(2, '0')}:${duration.seconds().toString().rjust(2, '0')}</span>`  
      action = `<a class="flex-fill" href="/play?game_id=${game.id}">SHOW</a>`
    } else {
      time = `<span>${moment(game.attributes.last_time_played).fromNow()}</span>`
      status = '<b class="text-info">PLAYING</b>';
      action = `<a class="flex-fill" href="/play?game_id=${game.id}">CONTINUE</a>`
    }

    $('#game-list').append(`
    <dt>
      <span>${game.attributes.rows} X ${game.attributes.columns}</span>
      ${status}
    </dt>
    <dd class="d-inline-flex">
      ${action}
      ${time}
    </dd>
    `)
  });
}

function renderPages(meta) {
  const currentPage = meta.current_page;
  const totalPages = meta.total_pages;

  $('#game-list-pages').empty();

  let i = 1;
  while (i <= totalPages) {
    $('#game-list-pages').append(`
      <a href="/profiles/me?page=${i}" class="page text-primary mr-2">${i}</a>
    `)
    i++;
  }
}

function getGames(page = 1) {
  apiClient.game.list((res, status) => {
    if (status == 'error') return;

    // LIST
    renderList(res.responseJSON.data);

    // PAGINATION
    renderPages(res.responseJSON.meta);

  }, page);
}

$(document).ready(() => {
  if (!apiClient.auth.authenticated()) {
    window.location.href = `/`
  }

  const params = new URLSearchParams(window.location.search)
  getGames(params.get('page'));

  $('#logout').on('click', e => {
    apiClient.auth.logout((res, status) => {
      window.location.href = '/';
    })
  });  
});