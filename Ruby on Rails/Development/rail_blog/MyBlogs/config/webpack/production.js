process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const environment = require('./environment')

module.exports = environment.toWebpackConfig()

warnings: true

const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const environment = require('./environment')

environment.plugins.delete('UglifyJs')

environment.plugins.append(
  'UglifyJs',
  new UglifyJsPlugin({
    sourceMap: true
  })
)

module.exports = environment.toWebpackConfig()