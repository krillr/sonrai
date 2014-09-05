class Sonrai.EventEmitter
  @listeners = {}

  @on: (event, cb) ->
    if not @listeners[event]?
      @listeners[event] = []
    if cb not in @listeners[event]
      @listeners[event].push(cb)

  @unbind: (event, cb) ->
    if not @listeners[event]?
      return
    if not cb in @listeners[event]
      return
    @listeners[event].splice(@listeners[event].indexOf(cb), 1)

  @emit: (event, args...) ->
    for listener in @listeners[event] || []
      listener.apply(this, args)

  constructor: ->
    @listeners = {}

  on: (event, cb) ->
    if not @listeners[event]?
      @listeners[event] = []
    if cb not in @listeners[event]
      @listeners[event].push(cb)

  unbind: (event, cb) ->
    if not @listeners[event]?
      return
    if not cb in @listeners[event]
      return
    @listeners[event].splice(@listeners[event].indexOf(cb), 1)

  emit: (event, args...) ->
    for listener in @listeners[event] || []
      listener.apply(this, args)

