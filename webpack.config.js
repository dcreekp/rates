var path = require('path');
var dist = path.resolve(__dirname, 'static');

var config = {
  entry: './index.js',
  output: {
    path: dist,
    filename: 'bundle.js'
  },
  module: {
    loaders: [{
        test: /\.js$/,
        loader: 'babel-loader',
        exclude: /node-modules/,
        query: {
          presets: ['es2015']
        }
      },{
        test: /\.tag$/,
        loader: 'tag-loader',
        exclude: /node-modules/,
      }
    ]
  }
}

module.exports = config
