helper={}

helper.tag="FormatHelper"

helper.isInt = (input) ->
	helper.validate input, /^[0-9]*$/

helper.validate = (input, regex) ->
	regexp = new RegExp regex
	regexp.test input

exports.FormatHelper=helper