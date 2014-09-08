Sonrai = require '../sonrai-bundle'

chai = require 'chai'

should = chai.should()
expect = chai.expect

describe 'Model', ->
  Database = new Sonrai.Databases.InMemory()

  class CatModel extends Sonrai.Model
    @fields: {
        name: Sonrai.Fields.StringField()
      }

  Cat = Database.register CatModel

  it 'should automatically add ID field', ->
    obj = new Cat()
    obj.fields.should.have.property 'id'

  it 'should automatically set a random uuid for the id', ->
    obj = new Cat()
    obj.get('id').should.match Sonrai.Utils.UUIDRegex

  it 'should allow setting and getting of field values', ->
    obj = new Cat()
    obj.set 'name', 'george'
    obj.get('name').should.equal 'george'

  it 'should not allow setting of non-existent fields', ->
    obj = new Cat()
    expect(-> obj.set 'bob', 'dole').to.throw Sonrai.Errors.FieldDoesNotExist

  it 'should not allow getting of non-existent fields', ->
    obj = new Cat()
    expect(-> obj.set 'bob').to.throw Sonrai.Errors.FieldDoesNotExist
