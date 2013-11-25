var express = require('../../node_modules/sails/node_modules/express');

module.exports = function(req, res, next) {
  var basicAuth = sails.config.basicAuth,
    username = basicAuth.username,
    password = basicAuth.password;

  if(!basicAuth.enabled) {
    return next();
  }

  express.basicAuth(username, password)(req, res, function() {
   return next();
  });

};