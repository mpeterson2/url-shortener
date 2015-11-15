var should = require('should');
var assert = require('assert');
var request = require('supertest')
var mongoose = require('mongoose');
var app = require('../app');

var originalUrl = "http://google.com";

beforeEach(function(done) {
  mongoose.connection.db.dropDatabase(done);
})

describe('Url creation', function() {
  it('should create a url when posted to', function(done) {

    request(app)
      .put('/')
      .send({originalUrl: originalUrl})
      .end(function(err, res) {
        res.body.should.have.property('originalUrl');
        assert.equal(originalUrl, res.body.originalUrl);

        done();
      });
  });

  it('should not create a new one if one already exists', function(done) {
    var id = null;
    request(app)
      .put('/')
      .send({originalUrl: originalUrl})
      .end(function(err, res) {
        id = res.body._id;

        request('localhost:3000')
          .put('/')
          .send({originalUrl: originalUrl})
          .end(function(err, res) {
            assert.equal(id, res.body._id);
            done();
          })
      });
  });
});

describe('Url fetching', function() {
    it('should redirect to the original url', function(done) {
      request(app)
        .put('/')
        .send({originalUrl: originalUrl})
        .end(function(err, res) {
          var shortUrl = res.body.shortUrl;

          request(app)
            .get('/' + shortUrl)
            .expect('Location', originalUrl, done);
        });
    });

    it('should 404 if a url does not exist', function(done) {
      request(app)
        .get('/' + 'does-not-exist')
        .expect(404, {error: 'Not Found'}, done);
    });

    it('should increment the click count when accessed', function(done) {
      request(app)
        .put('/')
        .send({originalUrl: originalUrl})
        .end(function(err, res) {
          var shortUrl = res.body.shortUrl;
          var numClicks = res.body.numClicks;

          request(app)
            .get('/' + shortUrl)
            .end(function(err, res) {
              request(app)
                .get('/' + shortUrl + '/count')
                .expect(200, {count: numClicks + 1}, done);
            });
        });
    });

    it('should not increment click count when asked for count', function(done) {
      request(app)
        .put('/')
        .send({originalUrl: originalUrl})
        .end(function(err, res) {
          var shortUrl = res.body.shortUrl;
          var numClicks = res.body.numClicks;

          request(app)
            .get('/' + shortUrl + '/count')
            .expect(200, {
              count: numClicks
            }, done);
        })
    });
});