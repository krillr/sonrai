Sonrai.Databases = {}

class Sonrai.Databases.BaseDatabase extends Sonrai.EventEmitter
  constructor: ->

  register: (model) ->
    model.db = this

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
