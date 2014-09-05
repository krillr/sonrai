Sonrai = require '../sonrai-bundle'
MyDatabase = new Sonrai.Databases.InMemory()
require('./test')(MyDatabase)
