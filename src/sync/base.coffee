Sonrai.Sync = {}

class Sonrai.Sync.SonraiSyncChangeModel extends Sonrai.Model
  fields: {
    timestamp: Sonrai.Fields.DateTimeField {
        default: -> return new Date().UTC()
      },
    modelName: Sonrai.Fields.StringField(),
    objectId: Sonrai.Fields.UUIDField(),
    changeType: Sonrai.Fields.StringField(),
    changeSet: Sonrai.Fields.ObjectField()
  }

class Sonrai.Sync.Base extends Sonrai.EventEmitter
  constructor: (@db) ->
    @changeModel = @db.register Sonrai.Sync.SonraiSyncChangeModel
    @db.on('save', @onSave)
    @db.on('delete', @onDelete)
    super

  onSave: (object) =>
    if object.modelName == 'SonraiSyncChangeModel'
      return
    changeSet = {}
    for fieldName, fieldObj of object.fields
      if fieldObj.changed
        changeSet[fieldName] = fieldObj.serialize()
    change = new @changeModel {
        modelName: object.modelName,
        objectId: object.get('id'),
        changeType: 'save',
        changeSet: changeSet
      }
    change.save()

  onDelete: (modelName, objectId) =>
    if modelName == 'SonraiSyncChangeModel'
      return
    change = new @changeModel {
        modelName: modelName,
        objectId: objectId,
        changeType: 'delete'
      }
    change.save()
