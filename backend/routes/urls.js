var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');
var Url = mongoose.model('Url');
var ShortId = require('shortid');

router.param('url', function(req, res, next, url) {
  Url.where({shortUrl: url}).findOne(function(err, url) {
    if(err)
      return next(err);

    if(!url)
      return res.status(404).json({error: 'Not Found'});

    req.url = url;
    return next();
  });
});

router.get('/:url', function(req, res, next) {
  var url = req.url;
  url.numClicks++;
  url.save(function(err, url) {
    if (err) {
      return next(err);
    }

    res.redirect(url.originalUrl);
  });
});

router.get('/:url/count', function(req, res, next) {
  var url = req.url;
  res.json({count: url.numClicks});
})

router.put('/', function(req, res, next) {
  Url.where({originalUrl: req.body.originalUrl})
    .findOne(function(err, url) {
      if (err || !url) {
        var newUrl = new Url(req.body);

        newUrl.shortUrl = ShortId.generate();
        newUrl.numClicks = 0;

        newUrl.save(function(err, url) {
          if (err) {
            return next(err);
          }

          res.json(url);
        });

      }

      else {
        res.json(url);
      }
    })
});

module.exports = router;