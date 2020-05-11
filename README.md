# minesweeper

Implementation of an minesweeper for Deviget challenge.

## The Game
Develop the classic game of [Minesweeper](https://en.wikipedia.org/wiki/Minesweeper_(video_game))

## The Challenge
The following is a list of items (prioritized from most important to least important) we wish to see:

* Design and implement  a documented RESTful API for the game (think of a mobile app for your API)

REST API using Ruby on Rails.

* Implement an API client library for the API designed above. Ideally, in a different language, of your preference, to the one used for the API

> API Client in JavaScript to be used on the FE.

* Persistence
* Ability to start a new game and preserve/resume the old ones

> Persisting the games in PostgreSQL. Current games and leaderboard
on Redis for faster responses.

* Ability to support multiple users/accounts

> Users on database, using `devise` for user authentication.

* When a cell with no adjacent mines is revealed, all adjacent squares will be revealed (and repeat)
* Ability to 'flag' a cell with a question mark or red flag
* Detect when game is over
* Time tracking
* Ability to select the game parameters: number of rows, columns, and mines

> Game logic implementation
 
## Deliverables we expect:
* URL where the game can be accessed and played (use any platform of your preference: heroku.com, aws.amazon.com, etc)
* Code in a public Github repo
* README file with the decisions taken and important notes
