class Model extends EventEmitter
  @db: null

  constructor: (@data) ->
    @fields = {}
    @data = @data || {}
    for fieldName, fieldObject of @_fields
      @fields[fieldName] = new fieldObject(@)
      if @data[fieldName]?
        @set(fieldName, @data[fieldName])

    if not @fields['id']?
      @fields['id'] = new (Fields.UUIDField({ default: Utils.uuid }))(@)

  name: ->
    return @.constructor.name

  db: ->
    return @.constructor.db

  set: (fieldName, value) ->
    if not @fields[fieldName]
      throw new Errors.FieldDoesNotExist(fieldName)
    field = @fields[fieldName]
    field.set(value)

  get: (fieldName) ->
    if not @fields[fieldName]
      throw new Errors.FieldDoesNotExist(field)
    return @fields[fieldName].get()

  serialize: ->
    serialized = {}
    for fieldName, field of @fields
      serialized[fieldName] = field.serialize()
    return serialized

  deserialize: (data) ->
    for fieldName, field in @fields
      if data[fieldName]?
        @field.deserialize(data[fieldName])

  save: ->
    return @db().save(@name(), @)
