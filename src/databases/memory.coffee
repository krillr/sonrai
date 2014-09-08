class Sonrai.Databases.InMemory extends Sonrai.Databases.Base
  constructor: ->
    super
    @data = {}

  _save: (modelName, object, onSuccess, onError) ->
    if not @data[modelName]?
      @data[modelName] = {}
    @data[modelName][object.get('id')] = object.serialize()
    onSuccess { modelName: modelName, object: object }

  _delete: (modelName, ObjectId, onSuccess, onError) ->
    delete @data[modelName][ObjectId]
    onSuccess()

  _count: (modelName, query, onSuccess, onError) ->
    @_fetch modelName, query, (results) ->
      onSuccess results.length
    , (err) ->
      onError err

  _fetch: (modelName, query, onSuccess, onError) ->
    filtered = []
    for k, v of @data[modelName]
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
      for fieldName, options of query.excludes
        if options instanceof Array
          if v[fieldName] in options
            add = false
            break
        else if options instanceof Object
          for operator, value of options
            if @operators[operator](value, v[fieldName])
              add = false
              break
        else
          if v[fieldName] == options
            add = false
            break
      if add
        obj = @getObject query.model.modelName, v.id, v
        filtered.push(obj)
    onSuccess(filtered)
