class EventEmitter
  @listeners = {}

  @on: (event, cb) ->
    if not @listeners[event]?
      @listeners[event] = []
    if cb not in @listeners[event]
      @listeners[event].push(cb)

  @unbind: (event, cb) ->
    if not @listeners[event]?
      return
    if not cb in @listeners[event]
      return
    @listeners[event].splice(@listeners[event].indexOf(cb), 1)

  @emit: (event, args...) ->
    for listener in @listeners[event] || []
      listener.apply(this, args)

  constructor: ->
    @listeners = {}

  on: (event, cb) ->
    if not @listeners[event]?
      @listeners[event] = []
    if cb not in @listeners[event]
      @listeners[event].push(cb)

  unbind: (event, cb) ->
    if not @listeners[event]?
      return
    if not cb in @listeners[event]
      return
    @listeners[event].splice(@listeners[event].indexOf(cb), 1)

  emit: (event, args...) ->
    for listener in @listeners[event] || []
      listener.apply(this, args)

Errors = {}

class Errors.ValidationFailed extends Error
  constructor: (value) ->
    @message = 'Invalid value: ' + value

class Errors.ModelNotInstantiated extends Error
  message: "Model must be instantiated to a database item to use this function."

class Errors.FieldDoesNotExist extends Error
  constructor: (fieldName) ->
    @message = "Field '" + fieldName + "' does not exist."

class Errors.InvalidOperator extends Error
  constructor: (operator) ->
    @message = "Invalid operator: " + operator
Utils = {
  intersect: (arr1, arr2) ->
    intersection = []
    for x in arr1
      if x in arr2
        intersection.push(x)
    return intersection

  exclude: (arr1, arr2) ->
    exclusion = []
    for x in arr1
      if x not in arr2
        exclusion.push(x)
    return exclusion

  extend: (obj1, obj2) ->
    for k, v of obj2
      obj1[k] = v

  rand: (x) ->
    return Math.floor(Math.random() * x)

  uuid: ->
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
      r = Math.random()*16|0
      v = if c == 'x' then r else (r&0x3|0x8)
      return v.toString(16)
    )
}

Databases = {}

class Databases.BaseDatabase extends EventEmitter
  constructor: ->
  operators: {
    'gte': (v1, v2) ->
      return v2 >= v1
    'gt': (v1, v2) ->
      return v2 > v1
    'lte': (v1, v2) ->
      return v2 <= v1
    'lt': (v1, v2) ->
      return v2 < v1
  }

  save: (modelName, object) ->

  delete: (modelName, object) ->

  deleteQuery: (modelName, query) ->
    objects = @fetch(modelName, query)
    for object in objects
      @delete(modelName, object.id)
    return
class Databases.InMemoryDatabase extends Databases.BaseDatabase
  constructor: ->
    super
    @models = {}

  save: (modelName, object) ->
    if not @models[modelName]?
      @models[modelName] = {}
    @models[modelName][object.get('id')] = object.serialize()
    return

  delete: (modelName, id) ->
    delete @models[modelName][id]

  fetch: (modelName, query) ->
    filtered = []
    for k, v of @models[modelName]
      add = true
      for fieldName, options of query.filters
        if options instanceof Array
          if v[fieldName] not in options
            add = false
            break
        else if options instanceof Object
          for operator, value of options
            if not @operators[operator](value, v[fieldName])
              add = false
              break
        else
          if v[fieldName] != options
            add = false
            break
        if not add
          break
      if add
        obj = new query.model()
        obj.deserialize(JSON.parse(JSON.stringify(v)))
        filtered.push(obj)
    return filtered
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
class Query extends EventEmitter
  validOperators: ['gt', 'gte', 'lt', 'lte']
  constructor: (@model) ->
    @filters = {}
    @excludes = {}

  clone: ->
    q = new Query(@model)
    q.filters = @filters
    q.excludes = @excludes
    return q

  filter: (filters) ->
    q = @clone()
    q.combine(q.filters, filters)
    return q

  exclude: (excludes) ->
    q = @clone()
    q.combine(q.excludes, excludes)
    return q

  combine: (set, inc) ->
    for field, options of inc
      if not @model.prototype._fields[field]?
        throw new Errors.FieldDoesNotExist(field)
      if not set[field]?
        set[field] = {}
      if options instanceof Array
        set[field] = options
      else if options instanceof Object
        keys = Object.keys(options)
        keys = Utils.exclude(keys, @validOperators)
        if keys.length
          throw new Errors.InvalidOperator(keys[0])
        Utils.extend(set[field], options)
      else
        set[field] = options

  delete: ->
    return @model.db.delete(@model.name, @)

  run: ->
    return @model.db.fetch(@model.name, @)
Fields = {}

Fields.BaseField = (options) ->
  class _Field extends EventEmitter
    constructor: (@object) ->
      @options = options || {}
      @set(@options.default || null)

    deserialize: (fieldData) ->
      if fieldData?
        @set(Number(fieldData))

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
        throw new Errors.ValidationFailed(value)

    get: ->
      return @value

  return _Field

Fields.NumberField = (options) ->
  class _Field extends Fields.BaseField(options)
    validate: (value) ->
      if isNaN(Number(value))
        return false
      return true and (super value)

  return _Field

Fields.DateTimeField = (options) ->
  class _Field extends Fields.BaseField(options)
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

Fields.UUIDField = (options) ->
  class _Field extends Fields.BaseField(options)
    validate: (value) ->
      regex = /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/i
      return regex.test(value) and (super value)

  return _Field
@EventEmitter = EventEmitter
@Databases = Databases
@Errors = Errors
@Fields = Fields
@Model = Model
@Query = Query
@Utils = Utils
