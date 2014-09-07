Sonrai = require '../../sonrai-bundle'

chai = require 'chai'

should = chai.should()
expect = chai.expect

describe 'UUIDField', ->
  it 'should accept a default value', ->
    field = new (Sonrai.Fields.UUIDField {
        default: '123e4567-e89b-12d3-a456-426655440000'
      })
    field.get().should.equal '123e4567-e89b-12d3-a456-426655440000'

  it 'should accept a function to fill in the default value', ->
    field = new (Sonrai.Fields.UUIDField {
        default: -> return '123e4567-e89b-12d3-a456-426655440000'
      })
    field.get().should.equal '123e4567-e89b-12d3-a456-426655440000'

  it 'should not allow an improperly-formatted string as a value', ->
    field = new (Sonrai.Fields.UUIDField())
    expect(-> field.set('a')).to.throw Sonrai.Errors.ValidationError

  it 'should properly validate a properly formatted string', ->
    field = new (Sonrai.Fields.UUIDField())
    field.set('123e4567-e89b-12d3-a456-426655440000')
    field.get().should.equal '123e4567-e89b-12d3-a456-426655440000'
