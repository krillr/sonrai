Q = require 'q'
Sonrai = require '../sonrai-bundle'

chai = require 'chai'
chai.use(require 'chai-as-promised')

should = chai.should()
expect = chai.expect

objects = [
    {
      name: "Fred",
      birthday: new Date(2009, 9, 12, 11, 30, 0),
      age: 5
    },
    {
      name: "Bob",
      birthday: new Date(2010, 9, 12, 11, 30, 0),
      age: 4
    },
    {
      name: "Jill",
      birthday: new Date(2011, 9, 12, 11, 30, 0),
      age: 3
    },
    {
      name: "Katie",
      birthday: new Date(2012, 9, 12, 11, 30, 0),
      age: 2
    },
    {
      name: "José",
      birthday: new Date(2013, 9, 12, 11, 30, 0),
      age: 1
    },
 ]

setUp = ->
  if window?
    a.b.c()
  Database = new Sonrai.Databases.InMemory()

  class CatModel extends Sonrai.Model
    @fields: {
        name: Sonrai.Fields.StringField(),
        birthday: Sonrai.Fields.DateTimeField(),
        age: Sonrai.Fields.NumberField()
      }

  Cat = Database.register CatModel

  funcs = []
  for data in objects
    obj = new Cat(data)
    funcs.push(obj.save())

  promise = Q.all(funcs).then(-> return Cat)

describe 'Query', ->
  it 'should query on { name: "Fred" } and return 1 object', ->
    setUp().then (model) ->
      model.query({ name: "Fred"}).count().should.eventually.equal(1)

  it 'should query on { name: ["Fred", "Jill"] } and return 2 objects', ->
    setUp().then (model) ->
      model.query({ name: ["Fred", "Jill"] }).count().should.eventually.equal(2)

  it 'should exclude on { name: "Fred" } and return 4 objects', ->
    setUp().then (model) ->
      model.query().exclude({ name: "Fred"}).count().should.eventually.equal(4)

  it 'should exclude on { name: ["Fred", "Jill"] } and return 3 objects', ->
    setUp().then (model) ->
      model.query().exclude({ name: ["Fred", "Jill"] }).count().should.eventually.equal(3)

  it 'should query on { age: { gte: 2 } } and return 4 objects', ->
    setUp().then (model) ->
      model.query({ age: { gte: 2 } }).count().should.eventually.equal(4)

  it 'should query on { age: { gt: 2 } } and return 3 objects', ->
    setUp().then (model) ->
      model.query({ age: { gt: 2 } }).count().should.eventually.equal(3)

  it 'should query on { age: { lte: 2 } } and return 2 objects', ->
    setUp().then (model) ->
      model.query({ age: { lte: 2 } }).count().should.eventually.equal(2)

  it 'should query on { age: { lt: 2 } } and return 1 objects', ->
    setUp().then (model) ->
      model.query({ age: { lt: 2 } }).count().should.eventually.equal(1)

  it 'should exclude { age: { gte: 2 } } and return 1 objects', ->
    setUp().then (model) ->
      model.query().exclude({ age: { gte: 2 } }).count().should.eventually.equal(1)

  it 'should exclude { age: { gt: 2 } } and return 2 objects', ->
    setUp().then (model) ->
      model.query().exclude({ age: { gt: 2 } }).count().should.eventually.equal(2)

  it 'should exclude { age: { lte: 2 } } and return 3 objects', ->
    setUp().then (model) ->
      model.query().exclude({ age: { lte: 2 } }).count().should.eventually.equal(3)

  it 'should exclude { age: { lt: 2 } } and return 4 objects', ->
    setUp().then (model) ->
      model.query().exclude({ age: { lt: 2 } }).count().should.eventually.equal(4)

  it 'should delete all documents matching { name: ["Fred", "Jill"] }, leaving 3 documents left', ->
    setUp().then (model) ->
      model.query({ name: ["Fred", "Jill"] }).delete().then ->
        model.query().count().should.eventually.equal(3)
