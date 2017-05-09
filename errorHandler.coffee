
###
  错误处理函数
###

NOTIFY = require('gulp-notify');

errorHandler = (error)->
  args = Array.prototype.slice.call(arguments)

  NOTIFY.onError({
    title: 'Compile Error',
    messages: '<%= error.message %>',
  }).apply(@, args)

module.exports = errorHandler