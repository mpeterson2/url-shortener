var gulp = require('gulp');
var nodemon = require('gulp-nodemon');
var childProcess = require('child_process');

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

gulp.task('test', ['mongodb'], function(cb) {
  childProcess.exec('mocha test/ -c test/config-test.js', function(err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);
    process.exit();
  });
});