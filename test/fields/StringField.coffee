Sonrai = require '../../sonrai-bundle'

chai = require 'chai'

should = chai.should()
expect = chai.expect

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
