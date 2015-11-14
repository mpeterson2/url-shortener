var gulp = require('gulp');
var nodemon = require('gulp-nodemon');
var childProcess = require('child_process');
var path = require('path');


gulp.task('default', ['mongodb', 'start']);

gulp.task('start', function() {
  return nodemon({
    script: './app',
    ignore: ['gulpfile.js', 'test/'],
    port: 3000
  });
});

gulp.task('mongodb', function() {
  return childProcess.exec('mongod');
});