Sonrai = require('../sonrai')
test = require('tape')

MyDatabase = new Sonrai.Databases.LocalStorageDatabase()

class MyModel extends Sonrai.Model
  @db: MyDatabase

  _fields: {
    myField: Sonrai.Fields.NumberField({ default: 1 }),
    dateField: Sonrai.Fields.DateTimeField({ default: ->
      return new Date()
    })
  }

test('General tests', (t) ->
  t.plan(1)
  s = new Date().getTime()
  for x in [0..10000]
    obj = new MyModel({ myField: Sonrai.Utils.rand(100) })
    obj.save()
  document.write((new Date().getTime()) - s)
 
  q = new Sonrai.Query(MyModel)
  q = q.filter({ myField: obj.get('myField') })
  results = q.run()

  t.equal(results[0].get('myField'), obj.get('myField'))
)
