Sonrai.Fields = {}

Sonrai.Fields.BaseField = (options) ->
  class _Field extends Sonrai.EventEmitter
    constructor: (@object, @name) ->
      @options = options || { required: false }
      @set(@options.default || null)

    deserialize: (fieldData) ->
      if fieldData?
        @set(fieldData)

    serialize: ->
      return @value

    validate: (value) ->
      return true

    set: (value) ->
      if value instanceof Function
        value = value(@)
      if @validate(value)
        @value = value
      else
        throw new Sonrai.Errors.ValidationFailed(@name, value)

    get: ->
      return @value

  return _Field

Sonrai.Fields.StringField = (options) ->
  class _Field extends Sonrai.Fields.BaseField(options)
    validate: (value) ->
      if value == null and not @options.required
        return true
      else if value == null and @options.required
        return false
      else if typeof value == 'string'
        return true
      return false

  return _Field

Sonrai.Fields.NumberField = (options) ->
  class _Field extends Sonrai.Fields.BaseField(options)
    validate: (value) ->
      if isNaN(Number(value))
        return false
      return true and (super value)

  return _Field

Sonrai.Fields.DateTimeField = (options) ->
  class _Field extends Sonrai.Fields.BaseField(options)
    validate: (value) ->
      if not value?
        return true
      if value instanceof Date
        return true and (super value)
      return false

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
