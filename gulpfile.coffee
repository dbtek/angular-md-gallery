# Source: https://github.com/leonidas/gulp-project-template
pkg          = require './package.json'
browserify   = require 'browserify'
browserSync  = require 'browser-sync'
chalk        = require 'chalk'
CSSmin       = require 'gulp-minify-css'
ecstatic     = require 'ecstatic'
filter       = require 'gulp-filter'
gulp         = require 'gulp'
bower        = require 'gulp-bower'
gutil        = require 'gulp-util'
jade         = require 'gulp-jade'
path         = require 'path'
prefix       = require 'gulp-autoprefixer'
prettyTime   = require 'pretty-hrtime'
source       = require 'vinyl-source-stream'
sourcemaps   = require 'gulp-sourcemaps'
streamify    = require 'gulp-streamify'
stylus       = require 'gulp-stylus'
uglify       = require 'gulp-uglify'
watchify     = require 'watchify'
markdown     = require 'gulp-markdown'
ghPages      = require 'gulp-gh-pages'
ngAnnotate   = require 'gulp-ng-annotate'
url          = require 'url'

production   = process.env.NODE_ENV is 'production'

config =
  scripts:
    source: './src/scripts/index.coffee'
    extensions: ['.coffee']
    destination: './public/js/'
    filename: 'bundle.js'
  templates:
    source: './src/**/*.jade'
    watch: ['./src/**/*.jade']
    destination: './public/'
  styles:
    source: './src/styles/main.styl'
    watch: './src/styles/*.styl'
    destination: './public/css/'
  assets:
    source: './src/assets/**/*'
    watch: './src/assets/**/*'
    destination: './public/'
  bower:
    source: './bower_components/**/*.*'
    watch: './bower_components/**/*.*'
    destination: './public/lib/'
  markdown:
    source: './src/views/**/*.md'
    watch: './src/views/**/*.md'
    destination: './public/views/'

handleError = (err) ->
  gutil.log err
  gutil.beep()
  this.emit 'end'

gulp.task 'scripts', ->

  bundle = browserify
    entries: [config.scripts.source]
    extensions: config.scripts.extensions
    debug: not production

  build = bundle.bundle()
    .on 'error', handleError
    .pipe source config.scripts.filename

  build.pipe (streamify ngAnnotate())
    .pipe (streamify uglify()) if production

  build
    .pipe gulp.dest config.scripts.destination

gulp.task 'templates', ->
  pipeline = gulp
    .src config.templates.source
    .pipe(jade(pretty: not production))
    .on 'error', handleError
    .pipe gulp.dest config.templates.destination

  pipeline = pipeline.pipe browserSync.reload(stream: true) unless production

  pipeline

gulp.task 'styles', ->
  styles = gulp.src config.styles.source
  styles = styles.pipe(sourcemaps.init()) unless production
  styles = styles.pipe stylus
      'include css': true

    .on 'error', handleError
    .pipe prefix 'last 2 versions', 'Chrome 34', 'Firefox 28', 'iOS 7'

  styles = styles.pipe(CSSmin()) if production
  styles = styles.pipe(sourcemaps.write '.') unless production
  styles = styles.pipe gulp.dest config.styles.destination

  unless production
    styles = styles
      .pipe filter '**/*.css'
      .pipe browserSync.reload(stream: true)

  styles

gulp.task 'bower', ->
  return bower()
    .pipe gulp.dest config.bower.destination

gulp.task 'assets', ->
  gulp
    .src config.assets.source
    .pipe gulp.dest config.assets.destination

gulp.task 'server', ->
  browserSync
    port:      9001
    server:
      baseDir: './public'

gulp.task 'markdown', ->
  pipeline = gulp.src config.markdown.source
        .pipe markdown()
        .pipe (gulp.dest config.markdown.destination)

  pipeline = pipeline.pipe browserSync.reload(stream: true) unless production

gulp.task 'deploy', ['build'], () ->
  remoteUrl = url.parse pkg.repository.url
  # Add travis secure to remote url
  options =
    remoteUrl: "#{remoteUrl.protocol}//#{process.env.GH_TOKEN}@#{remoteUrl.host}#{remoteUrl.pathname}"
  gulp.src './public/**/*'
    .pipe ghPages(options)

gulp.task 'watch', ->
  gulp.watch config.templates.watch, interval: 500, ['templates']
  gulp.watch config.styles.watch, interval: 500, ['styles']
  gulp.watch config.assets.watch, interval: 500, ['assets']
  gulp.watch config.bower.watch, interval: 500, ['bower']
  gulp.watch config.markdown.watch, interval: 500, ['markdown']

  bundle = watchify browserify
    entries: [config.scripts.source]
    extensions: config.scripts.extensions
    debug: not production
    cache: {}
    packageCache: {}
    fullPaths: true

  bundle.on 'update', ->
    gutil.log "Starting '#{chalk.cyan 'rebundle'}'..."
    start = process.hrtime()
    build = bundle.bundle()
      .on 'error', handleError
      .pipe source config.scripts.filename

    build
      .pipe gulp.dest config.scripts.destination
      .pipe(browserSync.reload(stream: true))

    gutil.log "Finished '#{chalk.cyan 'rebundle'}' after #{chalk.magenta prettyTime process.hrtime start}"

  .emit 'update'

gulp.task 'no-js', ['templates', 'markdown', 'styles', 'assets', 'bower']
gulp.task 'build', ['scripts', 'no-js']
# scripts and watch conflict and will produce invalid js upon first run
# which is why the no-js task exists.
gulp.task 'default', ['watch', 'no-js', 'server']
