class Sonrai.Databases.InMemory extends Sonrai.Databases.Base
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
    return filtered
