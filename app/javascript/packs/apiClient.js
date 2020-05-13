import $ from 'jquery';

//-------- Helpers
function post(url, data, cb) {
  $.ajax({
    type: "POST",
    url: url,
    data: data,
    complete: cb,
    dataType: 'json'
  });
}

function put(url, data, cb) {
  $.ajax({
    type: "PUT",
    url: url,
    data: data,
    complete: cb,
    dataType: 'json'
  });
}

function get(url, cb) {
  $.ajax({
    type: "GET",
    url: url,
    complete: cb,
    dataType: 'json'
  });
}

// TO IMPLEMENT
// GET /api/v1/games/{gameId} - Get the game from the player
// PUT /api/v1/games/current/stop
// PUT /api/v1/games/{gameId}/stop - Stop a game
// PUT /api/v1/games/current/restart
// PUT /api/v1/games/{gameId}/restart - Restart a game
// GET /api/v1/games - My list of games (non-anonymous)

function apiGame(baseUrl) {
  return {
    // POST /api/v1/games - Start a new game
    create: (data, cb) => { post(`${baseUrl}/games`, {}, cb) },
    // GET /api/v1/games/current - Get the most recent game
    getCurrent: (cb) => { get(`${baseUrl}/games/current`, cb) },
    // POST /api/v1/games/current/reveal
    revealCurrent: (x, y, cb) => { apiGame(baseUrl).reveal('current', x, y, cb) },
    reveal: (gameId, x, y, cb) => { put(`${baseUrl}/games/${gameId}/reveal`, { player_action: {x, y} }, cb) },
    // POST /api/v1/games/current/flag
    flagCurrent: (x, y, cb) => { apiGame(baseUrl).flag('current', x, y, cb) },
    flag: (gameId, x, y, cb) => { put(`${baseUrl}/games/${gameId}/flag`, { player_action: {x, y} }, cb) },
    // POST /api/v1/games/current/unflag - Perform actions on the game
    unflagCurrent: (x, y, cb) => { apiGame(baseUrl).unflag('unflag', x, y, cb) },
    unflag: (gameId, x, y, cb) => { put(`${baseUrl}/games/${gameId}/unflag`, { player_action: {x, y} }, cb) },
  }
}

class ApiClient {
  constructor({ baseUrl }) {
    this.baseUrl = baseUrl
    this.game = apiGame(baseUrl);
  }
}

export default new ApiClient({ baseUrl: process.env.API_URL });