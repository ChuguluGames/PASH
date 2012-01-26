class exports.FormatHelper
	self=@

	self.tag = "FormatHelper"

	self.isInt = (input) ->
		self.validate input, /^[0-9]*$/

	self.validate = (input, regex) ->
		regexp = new RegExp regex
		regexp.test input