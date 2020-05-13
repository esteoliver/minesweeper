const { environment } = require('@rails/webpacker')
const Dotenv = require('dotenv-webpack');
const variables = new Dotenv();
process.env = variables.definitions;

const webpack = require('webpack');
environment.plugins.append('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

module.exports = environment
