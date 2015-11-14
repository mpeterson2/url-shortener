#!/usr/bin/env node

var express = require('express');
var path = require('path');
var app = express();
var commandLineArgs = require('command-line-args');
var bodyParser = require('body-parser');
var mongoose = require('mongoose');
require('./models/url');

// Parse command line args
var cli = commandLineArgs([
  {name: 'config', alias: 'c', type: String, defaultValue: './config'}
]);
var options = cli.parse(process.argv);

// Get the config
var config = require('./' + options.config);

// Connect to MongoDB
mongoose.connect(config.db.url);

// Setup express extensions
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

// Start the server
var port = process.env.PORT || 3000;
var server = app.listen(port);

// Setup routes
var urlRoutes = require('./routes/urls');
app.use('/', urlRoutes);

module.exports = app;