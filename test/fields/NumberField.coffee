Sonrai = require '../../sonrai-bundle'

chai = require 'chai'

should = chai.should()
expect = chai.expect

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
