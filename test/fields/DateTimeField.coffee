Sonrai = require '../../sonrai-bundle'

chai = require 'chai'
chai.use require 'chai-datetime'

should = chai.should()
expect = chai.expect

describe 'DateTimeField', ->
  it 'should accept a default value', ->
    field = new (Sonrai.Fields.DateTimeField {
        default: new Date(2009,9,12,11,30,23)
      })
    field.get().should.equalDate new Date(2009,9,12,11,30,23)
    field.get().should.equalTime new Date(2009,9,12,11,30,23)

  it 'should accept a function to fill in the default value', ->
    generate = ->
      return new Date(2009,9,12,11,30,23)
    field = new (Sonrai.Fields.DateTimeField {
        default: generate
      })
    field.get().should.equalDate new Date(2009,9,12,11,30,23)
    field.get().should.equalTime new Date(2009,9,12,11,30,23)

  it 'should not allow a non-date as a value', ->
    field = new (Sonrai.Fields.DateTimeField())
    expect(-> field.set('a')).to.throw Sonrai.Errors.ValidationError

  it 'should serialize to milliseconds since epoch...', ->
    field = new (Sonrai.Fields.DateTimeField())
    field.set new Date(2014,9,12,4,30,30)
    field.serialize().should.equal new Date(2014,9,12,4,30,30).getTime()
