class Sonrai.Model extends Sonrai.EventEmitter
  @db: null

  @query: (filters) ->
    q = new Sonrai.Query this
    if filters?
      q = q.filter(filters)
    return q

  @new: (fields) ->
    class Subclass extends @
      @fields: fields
    return Subclass

  @fromFixtures: (fixtures) ->
    return (new @ data for data in fixtures)

  constructor: (data) ->
    @field_classes = @.constructor.fields
    @fields = {}
    data = data || {}
    for fieldName, fieldObject of @field_classes
      @fields[fieldName] = new fieldObject(@, fieldName)
      if data[fieldName]?
        @set(fieldName, data[fieldName])

    if not @fields['id']?
      @fields['id'] = new (Sonrai.Fields.UUIDField({ default: Sonrai.Utils.uuid }))(@, 'id')
    super

  set: (fieldName, value) ->
    if not @fields[fieldName]?
      throw new Sonrai.Errors.FieldDoesNotExist(fieldName)
    field = @fields[fieldName]
    field.set(value)

  get: (fieldName) ->
    if not @fields[fieldName]?
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

  save: =>
    promise = @db.save(@modelName, @)
    promise.then ->
      @emit 'save', @
      @.constructor.emit 'save', @
    return promise

  delete: (cb) =>
    promise = @db.delete(@modelName, @.get('id'))
    promise.then (result) =>
      @.constructor.emit 'delete', @
      @emit 'delete', @
    return promise
