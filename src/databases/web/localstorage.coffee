class Sonrai.Databases.Web.LocalStorage extends Sonrai.Databases.InMemory
  constructor: ->
    super
    @localStorage = window.localStorage
    for k in Object.keys(@localStorage)
      if Sonrai.Utils.startswith(k, 'sonrai.')
        [_, modelName, objectId] = k.split(".")
        if not @data[modelName]?
          @data[modelName] = {}
        @data[modelName][objectId] = JSON.parse(@localStorage[k])

  save: (modelName, object) ->
    super modelName, object
    @localStorage['sonrai.' + modelName + "." + object.get('id')] = JSON.stringify(@data[modelName][object.get('id')])
    return

  delete: (modelName, id) ->
    super modelName, id
    delete @localStorage['sonrai.' + modelName + "." + id]

