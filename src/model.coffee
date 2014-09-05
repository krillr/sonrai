class Sonrai.Model extends Sonrai.EventEmitter
  @db: null

  @query: (filters) ->
    return new Sonrai.Query(this)

  @new: (fields) ->
    class Subclass extends @
      fields: fields
    return Subclass

  constructor: (data) ->
    @field_classes = @fields
    @fields = {}
    data = data || {}
    for fieldName, fieldObject of @field_classes
      @fields[fieldName] = new fieldObject(@, fieldName)
      if data[fieldName]?
        @set(fieldName, data[fieldName])

    if not @fields['id']?
      @fields['id'] = new (Sonrai.Fields.UUIDField({ default: Sonrai.Utils.uuid }))(@)

  name: ->
    return @.constructor.name

  db: ->
    return @.constructor.db

  delete: ->

  set: (fieldName, value) ->
    if not @fields[fieldName]
      throw new Sonrai.Errors.FieldDoesNotExist(fieldName)
    field = @fields[fieldName]
    field.set(value)

  get: (fieldName) ->
    if not @fields[fieldName]
      throw new Sonrai.Errors.FieldDoesNotExist(field)
    return @fields[fieldName].get()

  serialize: ->
    serialized = {}
    for fieldName, field of @fields
      serialized[fieldName] = field.serialize()
    return serialized

  deserialize: (data) ->
    for fieldName, field of @fields
      if data[fieldName]?
        field.deserialize(data[fieldName])

  save: (cb) ->
    return @db.save(@name(), @, cb)
