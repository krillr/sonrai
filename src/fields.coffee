Sonrai.Fields = {}

Sonrai.Fields.BaseField = (options) ->
  class _Field extends Sonrai.EventEmitter
    constructor: (@object, @name) ->
      @options = options || { required: false }
      @set(@options.default || null)
      @changed = false
      super

    deserialize: (fieldData) ->
      if fieldData?
        @set(fieldData)

    serialize: ->
      return @value

    validate: (value) ->
      if not value? and @options.required
        return false
      return true

    set: (value) ->
      if value instanceof Function
        value = value(@)
      if @validate(value)
        @value = value
        @changed = true
      else
        throw new Sonrai.Errors.ValidationFailed(@name, value)

    get: ->
      return @value

  return _Field

Sonrai.Fields.StringField = (options) ->
  class _Field extends Sonrai.Fields.BaseField(options)
    validate: (value) ->
      if value? and typeof value != 'string'
        return false
      return true and (super value)

  return _Field

Sonrai.Fields.NumberField = (options) ->
  class _Field extends Sonrai.Fields.BaseField(options)
    validate: (value) ->
      if value? and isNaN(Number(value))
        return false
      return true and (super value)

  return _Field

Sonrai.Fields.DateTimeField = (options) ->
  class _Field extends Sonrai.Fields.BaseField(options)
    validate: (value) ->
      if value? and not value instanceof Date
        return false
      return true and (super value)

    serialize: ->
      if @value?
        return @value.getTime()
      return null

    deserialize: (fieldData) ->
      return new Date(fieldData)

  return _Field

Sonrai.Fields.UUIDField = (options) ->
  class _Field extends Sonrai.Fields.BaseField(options)
    validate: (value) ->
      regex = /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/i
      return regex.test(value) and (super value)

  return _Field
