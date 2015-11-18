#!/usr/bin/env node

var path = require('path');
var mongoose = require('mongoose');
var bodyParser = require('body-parser');
var commandLineArgs = require('command-line-args');

require('./models/url');
var app = require('express')();
var urlRoutes = require('./routes/urls');


// Parse command line args
var cli = commandLineArgs([
  { name: 'config', alias: 'c', type: String, defaultValue: './config' }
]);
var options = cli.parse(process.argv);
var port = process.env.PORT || 3000; // TODO: Add command line option as well

var config = require('./' + options.config);

mongoose.connect(config.db.url);

// Setup express middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

// Routes
app.use('/', urlRoutes);

// Initialize Server
app.listen(port);
