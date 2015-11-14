var express = require('express');
var path = require('path');
var app = express();
var bodyParser = require('body-parser');
var config = require('./config');
var mongoose = require('mongoose');
require('./models/url');

mongoose.connect(config.db.url);

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

var port = process.env.PORT || 3000;
var server = app.listen(port);

var urlRoutes = require('./routes/urls');
app.use('/', urlRoutes);

app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.json(err);
        console.log(err);
    });
}

module.exports = app;