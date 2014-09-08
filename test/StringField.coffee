Sonrai = require '../sonrai-bundle'

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

  it 'should restrict values to a given set of choices', ->
    field = new (Sonrai.Fields.StringField {
      choices: ['a', 'b']
    })
    expect(-> field.set('c')).to.throw Sonrai.Errors.InvalidChoice
    expect(-> field.set('b')).to.not.throw Sonrai.Errors.InvalidChoice
    field.get().should.equal 'b'

  it 'should not allow min option', ->
    expect(-> new (Sonrai.Fields.StringField { min:1 })).to.throw Sonrai.Errors.ConfigurationError

  it 'should not allow max option', ->
    expect(-> new (Sonrai.Fields.StringField { max:1 })).to.throw Sonrai.Errors.ConfigurationError

  it 'should not allow a non-string as a value', ->
    field = new (Sonrai.Fields.StringField())
    expect(-> field.set(1)).to.throw Sonrai.Errors.ValidationError

  it 'should serialize... to a string...', ->
    field = new (Sonrai.Fields.StringField())
    field.set 'facepalm'
    field.serialize().should.equal 'facepalm'
