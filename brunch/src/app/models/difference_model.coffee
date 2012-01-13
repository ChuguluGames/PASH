# table definition
DifferenceDefinition = persistence.define 'difference', {}

# relations
#DifferenceDefinition.hasMany('difference_points', DifferencePointModel, 'difference')

# custom methods
#DiffrenceDefinition.fetchSelected = ->
#  DiffrenceDefinition.all().filter("first_image_url", '=', 'lolo42.jpg')

# making it visible outside as Model
exports.DifferenceModel = DifferenceDefinition
