class Sonrai.Databases.InMemory extends Sonrai.Databases.Base
  constructor: ->
    super
    @models = {}

  save: (modelName, object, cb) ->
    if not @models[modelName]?
      @models[modelName] = {}
    @models[modelName][object.get('id')] = object.serialize()
    if cb?
      cb()

  delete: (modelName, id, cb) ->
    delete @models[modelName][id]
    if cb?
      cb()

  fetch: (modelName, query, cb) ->
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
        obj = new query.model()
        obj.deserialize(JSON.parse(JSON.stringify(v)))
        filtered.push(obj)
    if cb?
      cb(filtered)
