class Sonrai.Databases.InMemory extends Sonrai.Databases.Base
  constructor: ->
    super
    @data = {}

  save: (modelName, object, cb) ->
    if not @data[modelName]?
      @data[modelName] = {}
    @data[modelName][object.get('id')] = object.serialize()
    super modelName, object, cb

  delete: (modelName, ObjectId, cb) ->
    delete @data[modelName][ObjectId]
    super modelName, ObjectId, cb

  fetch: (modelName, query, cb) ->
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
    if cb?
      cb(filtered)
