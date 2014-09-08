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

  it 'should not allow a value to be set below a specified minimum', ->
    field = new (Sonrai.Fields.NumberField({ min:new Date(2009,1,1) }))
    expect(-> field.set new Date(2009,1,1)).to.not.throw Sonrai.Errors.ValidationError
    expect(-> field.set new Date(2008,12,31)).to.throw Sonrai.Errors.ValidationError

  it 'should not allow a value to exceed a specified maximum', ->
    field = new (Sonrai.Fields.NumberField({ max:new Date(2008,12,31) }))
    expect(-> field.set new Date(2008,12,31)).to.not.throw Sonrai.Errors.ValidationError
    expect(-> field.set new Date(2009,1,1)).to.throw Sonrai.Errors.ValidationError

  it 'should not allow choices option', ->
    expect(-> new (Sonrai.Fields.DateTimeField { choices:[] })).to.throw Sonrai.Errors.ConfigurationError

  it 'should not allow a non-date as a value', ->
    field = new (Sonrai.Fields.DateTimeField())
    expect(-> field.set('a')).to.throw Sonrai.Errors.ValidationError

  it 'should serialize to milliseconds since epoch...', ->
    field = new (Sonrai.Fields.DateTimeField())
    field.set new Date(2014,9,12,4,30,30)
    field.serialize().should.equal new Date(2014,9,12,4,30,30).getTime()
