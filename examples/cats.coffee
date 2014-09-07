Sonrai = require '../src/sonrai-bundle'
MyDatabase = new Sonrai.Databases.InMemory()
Synchronizer = new Sonrai.Sync.Base MyDatabase

class CatModel extends Sonrai.Model
  @fields: {
      name     : Sonrai.Fields.StringField(),
      gender   : Sonrai.Fields.StringField(),
      birthday : Sonrai.Fields.DateTimeField({ default: -> new Date() })
    }

Cat = MyDatabase.register CatModel

obj = new Cat {
    name: "George",
    gender: "male"
  }
obj.save()

obj2 = new Cat {
    name: "Bill",
    gender: "female"
  }
obj2.save()

q = Cat.query().filter({ name: "George" })
q.end (results) ->
  console.log(results)
  results[0].delete()
  console.log(results)
  q.end (results) ->
    console.log(results)
