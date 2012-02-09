class exports.FormatHelper
	@tag = "FormatHelper"

	@isInt = (input) ->
		@validate input, /^[0-9]+$/

	@validate = (input, regex) ->
		regexp = new RegExp regex
		regexp.test input