/* html模板 */
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const excludeChunks = ['index', 'searchID'];

// 跳过模块
function excludeChunksCopy(name){
  const excludeChunks2 = [].concat(excludeChunks);
  const index = excludeChunks2.indexOf(name);
  excludeChunks2.splice(index, 1);
  return excludeChunks2;
}

// 开发环境
function devHtmlWebpackPlugin(name, file){
  return new HtmlWebpackPlugin({
    filename: name + '.html',
    inject: true,
    hash: true,
    template: path.join(__dirname, file),
    excludeChunks: excludeChunksCopy(name)
  })
}

// 生产环境
function proHtmlWebpackPlugin(name, file){
  return new HtmlWebpackPlugin({
    filename: name + '.html',
    inject: true,
    hash: true,
    template: path.join(__dirname, file),
    minify: {
      minifyCSS: true,
      minifyJS: true
    },
    excludeChunks: excludeChunksCopy(name)
  })
}

module.exports = {
  devHtmlWebpackPlugin,
  proHtmlWebpackPlugin
};