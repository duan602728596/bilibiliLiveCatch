/* 开发环境 */
const path = require('path');
const { devHtmlWebpackPlugin } = require('./htmlWebpackPlugin');
const config = require('./webpack.config');
const sassConfig = require('./sass.config');

/* 合并配置 */
module.exports = config({
  output: {
    path: path.join(__dirname, '../build'),
    filename: 'script/[name].js',
    chunkFilename: 'script/[name]_chunk.js'
  },
  devtool: 'cheap-module-source-map',
  module: {
    rules: [
      { // sass
        test: /^.*\.sass$/,
        use: ['style-loader', 'css-loader', sassConfig]
      },
      { // css
        test: /^.*\.css$/,
        use: ['style-loader', 'css-loader'],
        exclude: /(bootstrap)/
      },
      { // pug
        test: /^.*\.pug$/,
        use: [
          {
            loader: 'pug-loader',
            options: {
              pretty: true,
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
              name: '[name].[ext]',
              outputPath: 'file/'
            }
          }
        ]
      }
    ]
  },
  plugins: [
    // html模板
    devHtmlWebpackPlugin('index', '../src/modules/index/entry/index.pug'),
    devHtmlWebpackPlugin('searchID', '../src/modules/searchID/entry/searchID.pug'),
    devHtmlWebpackPlugin('cut', '../src/modules/cut/entry/cut.pug')
  ]
});