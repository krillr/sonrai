Sonrai.Fields = {}

Sonrai.Fields.BaseField = (options) ->
  class _Field extends Sonrai.EventEmitter
    constructor: (@object, @name) ->
      @options = options || { required: false }
      @changed = false
      super

    deserialize: (fieldData) ->
      if fieldData?
        @set(fieldData)

    serialize: ->
      if not @value? and @options.default
        @set(@options.default)
      return @value

    validate: (value) ->
      if not value? and @options.required
        return false
      if @options.choices? and value not in @options.choices
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
      if not @value? and @options.default
        @set(@options.default)
      return @value

  return _Field

Sonrai.Fields.StringField = (options) ->
  class _Field extends Sonrai.Fields.BaseField(options)
    constructor: (@object, @name) ->
      super @object, @name
      if @options.min? or @options.max?
        throw new Sonrai.Errors.ConfigurationError 'StringField does not support min or max'
    validate: (value) ->
      if value? and typeof value != 'string'
        return false
      return true and (super value)

  return _Field

Sonrai.Fields.NumberField = (options) ->
  class _Field extends Sonrai.Fields.BaseField(options)
    constructor: (@object, @name) ->
      super @object, @name
    set: (value) ->
      super value
      if not (value instanceof Number) and not (value instanceof Function)
        @value = Number value
    validate: (value) ->
      if value? and isNaN(Number(value))
        return false
      value = Number(value)
      if @options.min? and value < @options.min
        return false
      if @options.max? and value > @options.max
        return false
      return true and (super value)

  return _Field

Sonrai.Fields.DateTimeField = (options) ->
  class _Field extends Sonrai.Fields.BaseField(options)
    constructor: (@object, @name) ->
      super @object, @name
      if @options.choices?
        throw new Sonrai.Errors.ConfigurationError 'DateTimeField does not support choices'
    validate: (value) ->
      if value? and not (value instanceof Date)
        return false
      if @options.min? and value < @options.min
        return false
      if @options.max? and value > @options.max
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
    constructor: (@object, @name) ->
      super @object, @name
      if @options.choices?
        throw new Sonrai.Errors.ConfigurationError 'UUIDField does not support choices'
      if @options.min? or @options.max?
        throw new Sonrai.Errors.ConfigurationError 'UUIDField does not support min or max'
    validate: (value) ->
      return Sonrai.Utils.UUIDRegex.test(value) and (super value)

  return _Field

Sonrai.Fields.ObjectField = (options) ->
  class _Field extends Sonrai.Fields.BaseField(options)
    constructor: (@object, @name) ->
      super @object, @name
      if @options.choices?
        throw new Sonrai.Errors.ConfigurationError 'ObjectField does not support choices'
      if @options.min? or @options.max?
        throw new Sonrai.Errors.ConfigurationError 'ObjectField does not support min or max'
    validate: (value) ->
      try
        JSON.stringify(value)
        return (typeof value == 'object') and (super value)
      catch
        return false

