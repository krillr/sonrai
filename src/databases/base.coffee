Sonrai.Databases = {
  Web: {},
  Node: {}
}

class Sonrai.Databases.Base extends Sonrai.EventEmitter
  models: {},
  objectCache: {},

  getObject: (modelName, id, data) ->
    obj = @objectCache[modelName][id]
    if not obj?
      obj = new @models[modelName]()
      @objectCache[modelName][id] = obj
    if data?
      obj.deserialize(data)
    return obj

  register: (model) ->
    @objectCache[model.name] = {}
    db = @
    class RegisteredModel extends model
      @originalClass: model
      originalClass: model
      @modelName: model.name
      modelName: model.name
      @db: db
      db: db
    @models[model.name] = RegisteredModel
    @emit 'register', RegisteredModel
    return RegisteredModel

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

  save: (modelName, object, cb) ->
    if object.get('id') not in @objectCache[modelName]
      @objectCache[modelName][object.get('id')] = object
    @emit 'save', object
    for fieldName, fieldObj of object.fields
      fieldObj.changed = false
    if cb?
      cb()

  delete: (modelName, objectId, cb) ->
    @emit 'delete', modelName, objectId
    delete @objectCache[objectId]
    if cb?
      cb()

  deleteQuery: (modelName, query, cb) ->
    objects = @fetch(modelName, query)
    for object in objects
      @delete(modelName, object.id)
    if cb?
      cb()
