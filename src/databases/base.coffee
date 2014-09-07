Sonrai.Databases = {
  Web: {},
  Node: {}
}

class Sonrai.Databases.Base extends Sonrai.EventEmitter
  register: (model) ->
    db = this
    class RegisteredModel extends model
      @modelName: model.name
      modelName: model.name
      @db: db
      db: db
    @emit 'register', model, RegisteredModel
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
    @emit 'save', object
    if cb?
      cb()

  delete: (modelName, object, cb) ->
    @emit 'delete', object
    if cb?
      cb()

  deleteQuery: (modelName, query, cb) ->
    objects = @fetch(modelName, query)
    for object in objects
      @delete(modelName, object.id)
    if cb?
      cb()
