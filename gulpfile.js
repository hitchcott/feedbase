var del = require('del')
var exec = require('child_process').exec
var browserify = require('browserify')

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
var sass = require('gulp-sass')

var config = {
  production: util.env.production
}

var paths = {
  src:{
    imba: 'src/imba/**/*.imba',
    js: 'src/js/**/*.js',
    solContracts: ['src/sol/**/*.sol'],
    solTests: 'src/sol/test/**/*.sol',
    index: 'src/index.html',
    sass: 'src/sass/**/*.scss'
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
  .pipe(htmlmin({collapseWhitespace: true}))
  .pipe(gulp.dest(paths.dest.index))
  .pipe(livereload())
})

gulp.task('build-sass', function () {
  return gulp.src(paths.src.sass)
  .pipe(sass().on('error', sass.logError))
  .pipe(concat('app.css'))
  .pipe(gulp.dest(paths.dest.css))
  .pipe(livereload())

});

gulp.task('clean-js', function () {
  return del([paths.build.js])
})

gulp.task('copy-js', ['clean-js'], function (){
  return gulp.src(paths.src.js)
  .pipe(config.production ? uglify() : util.noop())
  .pipe(gulp.dest(paths.build.js))
})

gulp.task('clean-imba', function () {
  return del([paths.build.imba])
})

gulp.task('build-imba', ['clean-imba'], function () {
  return gulp.src(paths.src.imba)
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
  exec('dapple test', function(err,res,failed){
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

gulp.task('deploy', function(cb){
  exec('dapple run deploy.ds', function(err,res,failed){
    if(err){
      console.log(err)
    } else if (failed) {
      process.stdout.write(failed)
    }
    cb()
  })
})

gulp.task('clean-public', function () {
  return del([paths.dest.root+'/*'])
})

gulp.task('webserver', function() {
  return gulp.src(paths.dest.root).pipe(webserver({}));
});

var mergeJsSource = function() {
  return gulp.src([
    paths.build.js+'*.js',
    paths.build.dapple+'**/*.js',
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

gulp.task('default', ['clean-public', 'merge-all', 'build-sass', 'copy-index'])
