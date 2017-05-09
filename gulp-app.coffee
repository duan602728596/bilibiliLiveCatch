GULP = require('gulp')
PUG = require('gulp-pug')
SASS = require('gulp-sass')
COFFEE = require('gulp-coffee2')
IMAGEMIN = require('gulp-imagemin')
UTF8_CONVERT = require('gulp-utf8-convert')
BOM = require('gulp-bom')
DEL_GULPSASS_BLANK_LINES = require('del-gulpsass-blank-lines')
PRETTIFY = require('gulp-prettify')
CHANGED = require('gulp-changed')
PLUMBER = require('gulp-plumber')
ERRORHANDLER = require('./errorHandler.coffee')
SOURCE_MAPS = require('gulp-sourcemaps');
DIRNAME = __dirname


###
  pug
###

_pug = ()->
  GULP.src("#{ DIRNAME }/src/view/**/*.pug")
    .pipe(CHANGED("#{ DIRNAME }/build/view", {
      extension: '.html',
    }))
    .pipe(PLUMBER({
      errorHandler: ERRORHANDLER,
    }))
    .pipe(PUG({
      pretty: true
    }))
    .pipe(PRETTIFY({
      indent_size: 4,
      unformatted: ['br', 'var'],
    }))
    .pipe(DEL_GULPSASS_BLANK_LINES())
    .pipe(GULP.dest("#{ DIRNAME }/build/view"))


###
  sass
###

_sass = ()->
  GULP.src("#{ DIRNAME }/src/style/**/*.sass")
    .pipe(CHANGED("#{ DIRNAME }/build/style", {
      extension: '.css',
    }))
    .pipe(SOURCE_MAPS.init({
      loadMaps: true,
    }))
    .pipe(SASS({
      outputStyle: 'compact',
    })
    .on('error', SASS.logError))
    .pipe(DEL_GULPSASS_BLANK_LINES())
    .pipe(UTF8_CONVERT())
    .pipe(SOURCE_MAPS.write('./'))
    .pipe(GULP.dest("#{ DIRNAME }/build/style"))


###
  coffee
###

_coffee = ()->
  GULP.src("#{ DIRNAME }/src/script/**/*.coffee")
    .pipe(CHANGED("#{ DIRNAME }/build/script", {
      extension: '.js',
    }))
    .pipe(SOURCE_MAPS.init({
      loadMaps: true,
    }))
    .pipe(PLUMBER({
      errorHandler: ERRORHANDLER,
    }))
    .pipe(COFFEE())
    .pipe(UTF8_CONVERT())
    .pipe(BOM())
    .pipe(SOURCE_MAPS.write('./'))
    .pipe(GULP.dest("#{ DIRNAME }/build/script"))


###
  图片压缩
###

_img = ()->
  GULP.src("#{ DIRNAME }/src/image/**/*.*")
    .pipe(CHANGED("#{ DIRNAME }/build/image"))
    .pipe(IMAGEMIN())
    .pipe(GULP.dest("#{ DIRNAME }/build/image"))


###
  监视的文件流
###

_watch = ()->
  GULP.watch("#{ DIRNAME }/src/view/**/*.pug", GULP.series(_img, _pug))
  GULP.watch("#{ DIRNAME }/src/style/**/*.sass", GULP.series(_img, _sass))
  GULP.watch("#{ DIRNAME }/src/script/**/*.coffee", _coffee)
  return


###
  初始化执行
###
start = ()->
  GULP.task('default', GULP.series(
    GULP.parallel(_pug, _sass, _coffee, _img),
    _watch
  ))
  return


module.exports = start