const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  'window.jQuery': 'jquery',
  Popper: ['popper.js', 'default']
}));

environment.loaders.prepend('sass', {
  test: /\.(css|scss|sass)$/,
  use: [{
      loader: 'style-loader'
  }, {
      loader: 'css-loader'
  }, {
      loader: 'sass-loader',
        options: { 
          sassOptions: { includePaths } 
        }
  }]
});

module.exports = environment
