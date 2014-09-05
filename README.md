Clientside data model system inspired by MongoDB and the Django ORM, with offline storage support.

CoffeeScript Example
======
```
MyDatabase = new Sonrai.Databases.LocalStorageDatabase()

class MyModel extends Sonrai.Model
  _fields: {
    myField: Sonrai.Fields.NumberField({ default: 1 }),
    dateField: Sonrai.Fields.DateTimeField({ default: ->
      return new Date()
    })
  }

MyDatabase.register(MyModel)

obj = new MyModel({ myField: Sonrai.Utils.rand(100) })
obj.save()

q = new Sonrai.Query(MyModel)
q = q.filter({ myField: obj.get('myField') })
results = q.run()
```
