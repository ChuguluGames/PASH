# table definition
ItemDefinition = persistence.define 'item',
  identity        :	"INT"
  first_image_url :	"TEXT"
  second_image_url: "TEXT"

# indexes
ItemDefinition.index ['identity'], {unique: true}

# relations
# ItemDefinition.hasMany('differences', DifferenceModel, 'item')
# ItemDefinition.hasOne('first_image', ImageModel, null)
# ItemDefinition.hasOne('second_image', ImageModel, null)

ItemDefinition.prototype.differencesArray = []

ItemDefinition.prototype.fetchAll = (callback) ->
  self=@
  self.fetch 'first_image', (firstImage) ->
      self.fetch 'second_image', (secondImage) ->
          self.differences.list (c) ->
              self.differencesArray = c
              pointFetchCount = c.length
              for difference in c
                do (difference) ->
                  difference.fetchPoints (points) ->
                      if (--pointFetchCount == 0)
                        callback(self) if callback?

# custom methods
ItemDefinition.fetchSelected = (callback) ->
  PackModel.fetchSelected().list (packs) ->
    packIds = []
    packIds.push pack.id for pack in packs
    ItemDefinition.all().filter("pack", 'in', packIds).list callback

# custom mapping
ItemDefinition.fromJSON = (json) ->
  json = (if json.item? then json.item else json)
  itemData =
    identity        : json.identity
    first_image_url : json.first_image_url
    second_image_url: json.second_image_url
  item = new ItemDefinition(itemData)
  item.differences.add(DifferenceModel.fromJSON(diff)) for diff in json.differences
  item

# making it visible outside as Model
exports.ItemModel = ItemDefinition