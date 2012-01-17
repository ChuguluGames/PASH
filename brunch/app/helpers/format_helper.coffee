helper={}

helper.verbose=false
helper.tag="FormatHelper"

helper.log = (message) ->
  console.log "[" + helper.tag + "] " , message if message? && @verbose

helper.isInt = (input) ->
	helper.validate input, /^[0-9]*$/

helper.validate = (input, regex) ->
	regexp = new RegExp regex
	regexp.test input

exports.FormatHelper=helper