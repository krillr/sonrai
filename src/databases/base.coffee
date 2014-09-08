Q = require 'q'

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

  saveAll: (objects) ->
    calls = (object.save() for object in objects)
    return Q.all(calls)

  save: (modelName, object) ->
    response = Q.defer()

    if object.get('id') not in @objectCache[modelName]
      @objectCache[modelName][object.get('id')] = object
    @_save modelName, object, response.resolve, response.reject

    promise = response.promise
    return promise.then (result) =>
      @emit 'save', result.object
      for fieldName, fieldObj of result.object.fields
        fieldObj.changed = false

  delete: (modelName, objectId) ->
    response = Q.defer()
    
    @_delete modelName, objectId, response.resolve, response.reject

    response.promise.then ->
      @emit 'delete', modelName, objectId
      delete @objectCache[objectId]
    return response.promise

  count: (modelName, query) ->
    response = Q.defer()
    @_count modelName, query, response.resolve, response.reject
    return response.promise

  fetch: (modelName, query) ->
    response = Q.defer()
    @_fetch modelName, query, response.resolve, response.reject
    return response.promise

  deleteByQuery: (modelName, query) ->
    response = Q.defer()
    @fetch(modelName, query).then (result) =>
      deletions = (@delete(modelName, object.get 'id') for object in result)
      Q.all(deletions).then response.resolve
    return response.promise
