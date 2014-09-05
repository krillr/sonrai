Clientside data model system inspired by MongoDB and the Django ORM, with offline storage support.

CoffeeScript Example
======
```CoffeeScript
MyDatabase = new Sonrai.Databases.InMemory()

class CatModel extends Sonrai.Model
  _fields: {
    name: Sonrai.Fields.StringField(),
    gender: Sonrai.Fields.StringField(),
    birthday: Sonrai.Fields.DateTimeField({ default: ->
      return new Date()
    })
  }

Cat = MyDatabase.register(CatModel)

obj = new Cat({
    name: "George",
    gender: "male"
  })

obj.save()

q = Cat.query().filter({ name: "George" })
q.end (results) ->
  console.log(results)
```
