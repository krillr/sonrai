Sonrai = require '../../sonrai-bundle'

chai = require 'chai'
chai.use require 'chai-fuzzy'

should = chai.should()
expect = chai.expect

describe 'ObjectField', ->
  it 'should accept a default value', ->
    field = new (Sonrai.Fields.ObjectField {
        default: { 1:2 }
      })
    field.get().should.be.like { 1:2 }

  it 'should accept a function to fill in the default value', ->
    field = new (Sonrai.Fields.ObjectField {
        default: -> return { 1:2 }
      })
    field.get().should.be.like { 1:2 }

  it 'should not allow a non-object as a value', ->
    field = new (Sonrai.Fields.ObjectField())
    expect(-> field.set 'a').to.throw Sonrai.Errors.ValidationError
