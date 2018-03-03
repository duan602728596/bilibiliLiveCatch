const path = require('path');
const webpack = require('webpack');
const manifest = require('../.dll/manifest.json');

function config(options){
  const conf = {
    mode: process.env.NODE_ENV,
    entry: {
      index: path.join(__dirname, '../src/modules/index/entry/index.coffee'),
      searchID: path.join(__dirname, '../src/modules/searchID/entry/searchID.coffee'),
      cut: path.join(__dirname, '../src/modules/cut/entry/cut.coffee')
    },
    module: {
      rules: [
        { // coffeescript
          test: /^.*\.coffee$/,
          use: ['coffee-loader']
        },
        {
          test: /(dll\.js|common\.js)/,
          use: [
            {
              loader: 'file-loader',
              options: {
                name: '[name]_[hash].[ext]',
                outputPath: 'script/'
              }
            }
          ]
        },
        {
          test: /(bootstrap.*\.css)/,
          use: [
            {
              loader: 'file-loader',
              options: {
                name: '[name]_[hash].[ext]',
                outputPath: 'style/'
              }
            }
          ]
        },
        { // 图片
          test: /^.*\.(jpg|png|gif)$/,
          use: [
            {
              loader: 'url-loader',
              options: {
                limit: 3000,
                name: '[name]_[hash].[ext]',
                outputPath: 'image/'
              }
            }
          ]
        }
      ]
    },
    plugins: [
      // dll
      new webpack.DllReferencePlugin({
        context: __dirname,
        manifest: manifest
      })
    ]
  };

  /* 合并 */
  conf.module.rules = conf.module.rules.concat(options.module.rules);       // 合并rules
  conf.plugins = conf.plugins.concat(options.plugins);                      // 合并插件
  conf.output = options.output;                                             // 合并输出目录
  if('devtool' in options) conf.devtool = options.devtool;                  // 合并source-map配置

  return conf;
}

module.exports = config;