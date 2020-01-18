const mozjpeg = require('imagemin-mozjpeg')
const pngquant = require('imagemin-pngquant');
const imagemin = require('gulp-imagemin');
const gulp = require('gulp');

gulp.task('default', (done) => {
  gulp.src('deployables/build/static/images/*')
    .pipe(imagemin([
      pngquant({quality: [.50, .70]}),
      mozjpeg({quality: [.50, .70]})
    ]))
    .pipe(gulp.dest('deployables/build/static/images/'))
  done();
});
