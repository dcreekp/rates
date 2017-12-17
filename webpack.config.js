const webpack = require('webpack')
const path = require('path')

const config = {
  context: path.resolve(__dirname, 'src'),
  entry: './app.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js'
  },
  module: {
    rules: [{
      test: /\.js$/,
      include: path.resolve(__dirname, 'src'),
      use: [{
        loader: 'babel-loader',
        options: {
          presets: ['es2015-riot']
        }
      }]
    },{
      test: /\.css$/,
      include: path.resolve(__dirname, 'src/css'),
      use: [
        'style-loader',
        'css-loader'
      ]
    },{
      test: /\.tag$/,
      include: path.resolve(__dirname, 'src/tags'),
      use: [
        'tag-loader'
      ]
    }]
  }
}

module.exports = config
