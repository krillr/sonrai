Sonrai = require '../sonrai-bundle'
if window?
  MyDatabase = new Sonrai.Databases.Web.LocalStorage()
  require('./test')(MyDatabase)
