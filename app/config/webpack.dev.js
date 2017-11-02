/* 开发环境 */
const path = require('path');
const os = require('os');
const webpack = require('webpack');
const HappyPack = require('happypack');
const { devHtmlWebpackPlugin } = require('./htmlWebpackPlugin');
const config = require('./webpack.config');
const sassConfig = require('./sass.config');

const happyThreadPool = HappyPack.ThreadPool({
  size: os.cpus().length
});

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
        use: [
          {
            loader: 'happypack/loader',
            options: {
              id: 'sass_loader'
            }
          }
        ]
      },
      { // css
        test: /^.*\.css$/,
        use: [
          {
            loader: 'happypack/loader',
            options: {
              id: 'css_loader'
            }
          }
        ],
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
      }
    ]
  },
  plugins: [
    /* HappyPack */
    // sass
    new HappyPack({
      id: 'sass_loader',
      loaders: ['style-loader', 'css-loader', sassConfig],
      threadPool: happyThreadPool,
      verbose: true
    }),
    // css
    new HappyPack({
      id: 'css_loader',
      loaders: ['style-loader', 'css-loader'],
      threadPool: happyThreadPool,
      verbose: true
    }),
    // 允许错误不打断程序
    new webpack.NoEmitOnErrorsPlugin(),
    // html模板
    devHtmlWebpackPlugin('index', '../src/index.pug'),
    devHtmlWebpackPlugin('searchID', '../src/searchID.pug')
  ]
});