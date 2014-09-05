class Sonrai.Query extends Sonrai.EventEmitter
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
        throw new Sonrai.Errors.FieldDoesNotExist(field)
      if not set[field]?
        set[field] = {}
      if options instanceof Array
        set[field] = options
      else if options instanceof Object
        keys = Object.keys(options)
        keys = Sonrai.Utils.exclude(keys, @validOperators)
        if keys.length
          throw new Sonrai.Errors.InvalidOperator(keys[0])
        Sonrai.Utils.extend(set[field], options)
      else
        set[field] = options

  delete: ->
    return @model.db.delete(@model.name, @)

  run: ->
    return @model.db.fetch(@model.name, @)
