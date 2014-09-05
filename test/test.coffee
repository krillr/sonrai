Sonrai = require '../sonrai-bundle'
test = require 'tape'

MyDatabase = new Sonrai.Databases.InMemory()

class CatModel extends Sonrai.Model
  fields: {
    name: Sonrai.Fields.StringField(),
    gender: Sonrai.Fields.StringField(),
    birthday: Sonrai.Fields.DateTimeField { default: ->
      return new Date()
    }
  }

Cat = MyDatabase.register CatModel

test 'General tests', (t) ->
  t.plan(2)
  obj = new Cat {
      name: "George",
      gender: "male"
    }

  obj.save ->
    q = Cat.query().filter { name: "George" }
    q.end (results) ->
      t.equal results[0].get('name'), "George"

    q = Cat.query().exclude { name: "George" }
    q.end (results) ->
      t.equal results.length, 0
