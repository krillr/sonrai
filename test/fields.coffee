Sonrai = require '../sonrai-bundle'

chai = require 'chai'
chai.use require 'chai-datetime'

should = chai.should()
expect = chai.expect

###

  StringField Tests

###

describe 'StringField', ->
  it 'should accept a default value', ->
    field = new (Sonrai.Fields.StringField {
        default: '0xdeadb33f'
      })
    field.get().should.equal '0xdeadb33f'

  it 'should accept a function to fill in the default value', ->
    generate = ->
      return 'more beef!'
    field = new (Sonrai.Fields.StringField {
        default: generate
      })
    field.get().should.equal 'more beef!'

  it 'should not allow a non-string as a value', ->
    field = new (Sonrai.Fields.StringField())
    expect(-> field.set(1)).to.throw Sonrai.Errors.ValidationError

  it 'should serialize... to a string...', ->
    field = new (Sonrai.Fields.StringField())
    field.set 'facepalm'
    field.serialize().should.equal 'facepalm'


###

  NumberField Tests

###

describe 'NumberField', ->
  it 'should accept a default value', ->
    field = new (Sonrai.Fields.NumberField {
        default: 1
      })
    field.get().should.equal 1

  it 'should accept a function to fill in the default value', ->
    generate = ->
      return 2
    field = new (Sonrai.Fields.NumberField {
        default: generate
      })
    field.get().should.equal 2

  it 'should accept an string representation of an integer as a value', ->
    field = new (Sonrai.Fields.NumberField())
    expect(-> field.set('1')).to.not.throw Sonrai.Errors.ValidationError
    expect(field.get()).to.equal 1

  it 'should accept an string representation of an float as a value', ->
    field = new (Sonrai.Fields.NumberField())
    expect(-> field.set('1.1')).to.not.throw Sonrai.Errors.ValidationError
    expect(field.get()).to.equal 1.1

  it 'should not allow a non-number or non-numeric string as a value', ->
    field = new (Sonrai.Fields.NumberField())
    expect(-> field.set('a')).to.throw Sonrai.Errors.ValidationError

  it 'should serialize... to a number...', ->
    field = new (Sonrai.Fields.NumberField())
    field.set 3
    field.serialize().should.equal 3

###

  DateTimeField Tests

###
describe 'DateTimeField', ->
  it 'should accept a default value', ->
    field = new (Sonrai.Fields.NumberField {
        default: -> new Date(2009,9,12,11,30,23)
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
