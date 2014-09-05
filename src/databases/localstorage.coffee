class Sonrai.Databases.LocalStorage extends Sonrai.Databases.InMemory
  constructor: ->
    super
    @localStorage = window.localStorage
    for k in Object.keys(@localStorage)
      if Sonrai.Utils.startswith(k, 'sonrai.')
        [_, modelName, objectId] = k.split(".")
        if not @models[modelName]?
          @models[modelName] = {}
        @models[modelName][objectId] = JSON.parse(@localStorage[k])

  save: (modelName, object) ->
    super modelName, object
    @localStorage['sonrai.' + modelName + "." + object.get('id')] = JSON.stringify(@models[modelName][object.get('id')])
    return

  delete: (modelName, id) ->
    super modelName, id
    delete @localStorage['sonrai.' + modelName + "." + id]

