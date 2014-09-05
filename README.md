Clientside data model system inspired by MongoDB and the Django ORM, with offline storage support.

[![Circle CI](https://circleci.com/gh/krillr/sonrai.png?style=badge)](https://circleci.com/gh/krillr/sonrai)

CoffeeScript Example
======
```CoffeeScript
MyDatabase = new Sonrai.Databases.InMemory()

class CatModel extends Sonrai.Model
  fields: {
      name     : Sonrai.Fields.StringField(),
      gender   : Sonrai.Fields.StringField(),
      birthday : Sonrai.Fields.DateTimeField {
          default: ->
            return new Date()
        }
    }

Cat = MyDatabase.register CatModel

obj = new Cat {
    name: "George",
    gender: "male"
  }

obj.save()

q = Cat.query().filter({ name: "George" })
q.end (results) ->
  console.log results
```

Javascript Example
======
```JavaScript
MyDatabase = new Sonrai.Databases.InMemory()

CatModel = Sonrai.Model.new({
    name: Sonrai.Fields.StringField(),
    gender: Sonrai.Fields.StringField(),
    birthday: Sonrai.Fields.DateTimeField({
      default: function() {
        return new Date()
      }
    })
  })

Cat = MyDatabase.register(CatModel)

obj = new Cat({
    name: "George",
    gender: "male"
  })

obj.save(function() {
    q = Cat.query().filter({ name: "George" })
    q.end(function(results) {
      console.log(results)
    })
  })
```
