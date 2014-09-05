Sonrai.Databases = {
  Web: {},
  Node: {}
}

class Sonrai.Databases.Base extends Sonrai.EventEmitter
  constructor: ->

  register: (model) ->
    db = this
    class RegisteredModel extends model
      @db: db
      db: db
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
    if cb?
      cb()

  delete: (modelName, object, cb) ->
    if cb?
      cb()

  deleteQuery: (modelName, query, cb) ->
    objects = @fetch(modelName, query)
    for object in objects
      @delete(modelName, object.id)
    if cb?
      cb()
