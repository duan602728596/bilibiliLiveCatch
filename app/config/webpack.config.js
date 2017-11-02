const path = require('path');
const os = require('os');
const process = require('process');
const webpack = require('webpack');
const HappyPack = require('happypack');
const manifest = require('../.dll/manifest.json');

const happyThreadPool = HappyPack.ThreadPool({
  size: os.cpus().length
});

function config(options){
  const conf = {
    entry: {
      'index': path.join(__dirname, '../src/entry/index.coffee'),
      'searchID': path.join(__dirname, '../src/entry/searchID.coffee'),
      'cut': path.join(__dirname, '../src/entry/cut.coffee')
    },
    module: {
      rules: [
        { // coffeescript
          test: /^.*\.coffee$/,
          use: [
            {
              loader: 'happypack/loader',
              options: {
                id: 'coffee_loader'
              }
            }
          ]
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
      // 公共模块
      /*
      new webpack.optimize.CommonsChunkPlugin({
        name: 'vendor'
      }),
      */
      // 范围提升
      new webpack.optimize.ModuleConcatenationPlugin(),
      // dll
      new webpack.DllReferencePlugin({
        context: __dirname,
        manifest: manifest
      }),
      new webpack.DefinePlugin({
        'process.env': {
          NODE_ENV: JSON.stringify(process.env.NODE_ENV)
        }
      }),
      /* HappyPack */
      // coffeescript
      new HappyPack({
        id: 'coffee_loader',
        loaders: ['coffee-loader'],
        threadPool: happyThreadPool,
        verbose: true
      })
    ]
  };

  /* 合并 */
  conf.module.rules = conf.module.rules.concat(options.module.rules);       // 合并rules
  conf.plugins = conf.plugins.concat(options.plugins);                      // 合并插件
  conf.output = options.output;                                             // 合并输出目录
  if('devtool' in options){                                                 // 合并source-map配置
    conf.devtool = options.devtool;
  }

  return conf;
}

module.exports = config;