var mongoose = require('mongoose');

var urlSchema = mongoose.Schema({
  numClicks: Number,
  shortUrl: String,
  originalUrl: String
});

mongoose.exports = mongoose.model('Url', urlSchema);