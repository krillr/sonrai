// Generated by CoffeeScript 1.8.0
(function() {
  var MyDatabase, Sonrai;

  Sonrai = require('../sonrai-bundle');

  if (typeof window !== "undefined" && window !== null) {
    MyDatabase = new Sonrai.Databases.Web.LocalStorage();
    require('./test')(MyDatabase);
  }

}).call(this);