const mozjpeg = require('imagemin-mozjpeg')
const pngquant = require('imagemin-pngquant');
const imagemin = require('gulp-imagemin');
const gulp = require('gulp');

gulp.task('default', () => {
  gulp.src('public/static/images/*')
    .pipe(imagemin([
      pngquant({quality: '50'}),
      mozjpeg({quality: '50'})
    ]))
    .pipe(gulp.dest('public/static/images/min/'))
});
