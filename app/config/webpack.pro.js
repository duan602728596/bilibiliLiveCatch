/* 生产环境 */
const path = require('path');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const OptimizeCSSPlugin = require('optimize-css-assets-webpack-plugin');
const { proHtmlWebpackPlugin } = require('./htmlWebpackPlugin');
const config = require('./webpack.config');
const sassConfig = require('./sass.config');

/* 合并配置 */
module.exports = config({
  output: {
    path: path.join(__dirname, '../build'),
    filename: 'script/[name]_[chunkhash].js',
    chunkFilename: 'script/[name]_[chunkhash]_chunk.js'
  },
  module: {
    rules: [
      { // sass
        test: /^.*\.sass$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: ['css-loader', sassConfig]
        })
      },
      { // css
        test: /^.*\.css$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: ['css-loader']
        }),
        exclude: /(bootstrap)/
      },
      { // pug
        test: /^.*\.pug$/,
        use: [
          {
            loader: 'pug-loader',
            options: {
              name: '[name].html'
            }
          }
        ]
      },
      { // 矢量图片 & 文字
        test: /^.*\.(eot|svg|ttf|woff|woff2)$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[name]_[hash].[ext]',
              outputPath: 'file/',
              publicPath: '../file/'
            }
          }
        ]
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin({
      filename: 'style/[name]_[contenthash].css',
      allChunks: true
    }),
    new OptimizeCSSPlugin(),
    // html模板
    proHtmlWebpackPlugin('index', '../src/modules/index/entry/index.pug'),
    proHtmlWebpackPlugin('searchID', '../src/modules/searchID/entry/searchID.pug'),
    proHtmlWebpackPlugin('cut', '../src/modules/cut/entry/cut.pug')
  ]
});