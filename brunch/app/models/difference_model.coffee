# table definition
DifferenceDefinition = persistence.define 'difference', {}

# relations
# DifferenceDefinition.hasMany('difference_points', DifferencePointModel, 'difference')

# custom methods
# DifferenceDefinition.fetchSelected = ->
#  DifferenceDefinition.all().filter("first_image_url", '=', 'lolo42.jpg')

DifferenceDefinition.prototype.differencePointsArray = []

DifferenceDefinition.prototype.fetchPoints = (callback) ->
  self=@
  self.difference_points.list (points) ->
      self.differencePointsArray = points
      callback(points) if callback?

# custom mapping
DifferenceDefinition.fromJSON = (json) ->
  json = (if json.difference? then json.differece else json)
  difference = new DifferenceDefinition(identity: json.identity)
  difference.difference_points.add(DifferencePointModel.fromJSON(diffPoint)) for diffPoint in json.point_diffs
  difference

# making it visible outside as Model
exports.DifferenceModel = DifferenceDefinition
