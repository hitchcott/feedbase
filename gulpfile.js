var del = require('del')
var exec = require('child_process').exec
var browserify = require('browserify')
var bower = require('gulp-bower')

var gulp = require('gulp')
var source = require('vinyl-source-stream')
var buffer = require('vinyl-buffer')
var htmlmin = require('gulp-htmlmin')
var concat = require('gulp-concat')
var uglify = require('gulp-uglify')
var imba = require('gulp-imba')
var util = require('gulp-util')
var webserver = require('gulp-webserver')
var livereload = require('gulp-livereload')
var debug = require('gulp-debug')
var sass = require('gulp-ruby-sass')
var gulpsync = require('gulp-sync')(gulp)
var plumber = require('gulp-plumber')

var config = {
  production: util.env.production
}

var paths = {
  src:{
    imba: 'src/imba/**/*.imba',
    js: 'src/js/**/*.js',
    solContracts: 'src/sol/**/*.sol',
    solTests: 'src/sol/test/**/*.sol',
    index: 'src/index.html',
    sassRoot: 'src/style/main.scss',
    sass: 'src/style/**/*.scss',
    bower: 'bower_components'
  },
  build:{
    js: '.build/js/',
    imba:  '.build/imba/',
    dapple: '.build/dapple/',
    dappleBuild: '.build/dapple-build/'
  },
  dest: {
    root: 'dist',
    js: 'dist/js/',
    css: 'dist/css/',
    index: 'dist/'
  }
}

gulp.task('copy-index', function () {
  return gulp.src(paths.src.index)
  .pipe(gulp.dest(paths.dest.index))
  .pipe(livereload())
})

gulp.task('bower', function() {
  return bower().pipe(gulp.dest(paths.src.bower))
})

gulp.task('font', function() {
    return gulp.src(paths.src.bower + '/Materialize/font/**/*', { "base" : paths.src.bower + '/Materialize/font' })
    .pipe(gulp.dest(paths.dest.root + '/font'));
})

gulp.task('build-sass', function () {
  return sass(paths.src.sassRoot, {
    style: 'compressed',
    loadPath: [
      paths.src.sass,
      paths.src.bower + '/Materialize/sass'
    ]
  })
  .on('error', util.log)
  .pipe(concat('app.css'))
  .pipe(gulp.dest(paths.dest.css))
  .pipe(livereload())
})

gulp.task('clean-js', function () {
  return del([paths.build.js])
})

gulp.task('copy-js', ['clean-js'], function (){
  return gulp.src([
      paths.src.bower + '/jquery/dist/jquery.min.js',
      paths.src.bower + '/Materialize/dist/js/materialize.min.js',
      paths.src.js
  ])
  .pipe(config.production ? uglify() : util.noop())
  .pipe(gulp.dest(paths.build.js))
})

gulp.task('clean-imba', function () {
  return del([paths.build.imba])
})

gulp.task('build-imba', ['clean-imba'], function () {
  return gulp.src(paths.src.imba)
  .pipe(plumber())
  .pipe(imba())
  .pipe(config.production ? uglify() : util.noop())
  .pipe(gulp.dest(paths.build.imba))
})

gulp.task('build-dapple', function (cb) {
  exec('dapple build', function(err,res){
    if(err){ console.log(err) }
    browserify({
      entries: paths.build.dappleBuild+'js_module.js',
      standalone: 'dapple'
    })
    .bundle()
    .pipe(source('app.js'))
    .pipe(buffer())
    .pipe(config.production ? uglify() : util.noop())
    .pipe(gulp.dest(paths.build.dapple))
    .on('end', function(){
      del.sync([paths.build.dappleBuild])
      cb()
    })
  })
})

gulp.task('test-dapple', function(cb){
  process.stdout.write('Testing...\r')
  exec('dapple test -e evm', function(err,res,failed){
    if(err){
      console.log(err)
    } else if (failed) {
      process.stdout.write(failed)
    } else {
      process.stdout.write("\u001b[32mPassed all tests! \n")
    }
    cb()
  })
})

gulp.task('clean-dest', function () {
  return del([paths.dest.root+'/*'])
})

gulp.task('webserver', function() {
  return gulp.src(paths.dest.root).pipe(webserver({}));
});

var mergeJsSource = function() {
  return gulp.src([
    paths.build.dapple+'**/*.js',
    paths.build.js+'*.js',
    paths.build.imba+'*.js'
  ])
  .pipe(concat('app.js'))
  .pipe(gulp.dest(paths.dest.js))
  .pipe(livereload())
}

gulp.task('merge-all', ['copy-js','build-dapple','build-imba'], mergeJsSource)
gulp.task('merge-js', ['copy-js'], mergeJsSource)
gulp.task('merge-dapple', ['build-dapple'], mergeJsSource)
gulp.task('merge-imba', ['build-imba'], mergeJsSource)

gulp.task('watch', ['default', 'webserver'], function() {
  livereload.listen()
  gulp.watch('src/sol/**/*.sol', ['test-dapple'])
  gulp.watch(paths.src.js, ['merge-js'])
  gulp.watch(paths.src.imba, ['merge-imba'])
  gulp.watch(paths.src.solContracts, ['merge-dapple'])
  gulp.watch(paths.src.index, ['copy-index'])
  gulp.watch(paths.src.sass, ['build-sass'])
})

gulp.task('test', ['test-dapple'])

gulp.task('default', gulpsync.sync(['bower','clean-dest', 'font', 'build-sass', 'merge-all', 'copy-index']))
