import $ from 'jquery';

//-------- Helpers
function post(url, data, cb) {
  $.ajax({
    type: "POST",
    url: url,
    data: data,
    headers: JSON.parse(localStorage.getItem('currentPlayer')),
    complete: cb,
    dataType: 'json'
  });
}

function put(url, data, cb) {
  $.ajax({
    type: "PUT",
    url: url,
    data: data,
    headers: JSON.parse(localStorage.getItem('currentPlayer')),
    complete: cb,
    dataType: 'json'
  });
}

function get(url, cb) {
  $.ajax({
    type: "GET",
    url: url,
    headers: JSON.parse(localStorage.getItem('currentPlayer')),
    complete: cb,
    dataType: 'json'
  });
}

function destroy(url, cb) {
  $.ajax({
    type: "DELETE",
    url: url,
    complete: cb,
    headers: JSON.parse(localStorage.getItem('currentPlayer')),
    dataType: 'json'
  });
}

function storeToken(res) {
  localStorage.setItem('currentPlayer', JSON.stringify(
    {
      'access-token': res.getResponseHeader('access-token'),
      uid: res.getResponseHeader('uid'),
      client: res.getResponseHeader('client')
    }
  ));
}

function deleteToken() {
  localStorage.setItem('currentPlayer', '{}')
}

function apiAuth(baseUrl) {
  return {
    authenticated: () => { 
      return localStorage.getItem('currentPlayer') != "{}";
    },
    login: ({ nickname, password }, cb) => { 
      post(`${baseUrl}/auth/sign_in`, { player: { nickname, password } }, (res, status) => {
        if (status != 'error') {
          storeToken(res);
        }
        cb(res, status);
      }) 
    },
    logout: (cb) => { 
      destroy(`${baseUrl}/auth/sign_out`, (res, status) => {
        deleteToken();
        cb(res, status);
      })
    },
    register: ({ nickname, password, email }, cb) => { 
      post(`${baseUrl}/auth`, { player: { nickname, password, email } }, (res, status) => {
        if (status != 'error') {
          storeToken(res);
        }
        cb(res, status);
      })
    },
  }
}

// TO IMPLEMENT
// PUT /api/v1/games/current/stop
// PUT /api/v1/games/{gameId}/stop - Stop a game
// PUT /api/v1/games/current/restart
// PUT /api/v1/games/{gameId}/restart - Restart a game

function apiGame(baseUrl) {
  return {
    // GET /api/v1/games - My list of games (non-anonymous)
    list: (cb, page = 1) => { get(`${baseUrl}/games?page=${page}`, cb) },

    // GET /api/v1/games/{gameId} - Get indicated game
    get: (gameId, cb) => { get(`${baseUrl}/games/${gameId}`, cb) },

    // GET /api/v1/games/current - Get the most recent game
    getCurrent: (cb) => { apiGame(baseUrl).get('current', cb) },

    // POST /api/v1/games - Start a new game
    create: (data, cb) => { post(`${baseUrl}/games`, { game: data }, cb) },

    // POST /api/v1/games/current/reveal
    revealCurrent: (x, y, cb) => { apiGame(baseUrl).reveal('current', x, y, cb) },
    reveal: (gameId, x, y, cb) => { put(`${baseUrl}/games/${gameId}/reveal`, { player_action: {x, y} }, cb) },

    // POST /api/v1/games/current/flag
    flagCurrent: (x, y, cb) => { apiGame(baseUrl).flag('current', x, y, cb) },
    flag: (gameId, x, y, cb) => { put(`${baseUrl}/games/${gameId}/flag`, { player_action: {x, y} }, cb) },

    // POST /api/v1/games/current/unflag - Perform actions on the game
    unflagCurrent: (x, y, cb) => { apiGame(baseUrl).unflag('current', x, y, cb) },
    unflag: (gameId, x, y, cb) => { put(`${baseUrl}/games/${gameId}/unflag`, { player_action: {x, y} }, cb) },
  }
}

class ApiClient {
  constructor({ baseUrl }) {
    this.baseUrl = baseUrl;
    this.game = apiGame(baseUrl);
    this.auth = apiAuth(baseUrl);
  }
}

export default new ApiClient({ baseUrl: process.env.API_URL });