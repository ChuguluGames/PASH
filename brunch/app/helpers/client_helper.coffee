class exports.ClientHelper
	windowSize: null
	isAndroid : null
	isIOS     : null
	isIpad    : null
	isIPhone  : null
	isIPod    : null
	isRetina  : null
	resolution: null

	constructor: ->
		self=@
		self

	getUserAgent: ->
		self=@
		if !self.userAgent?
			self.userAgent = navigator.userAgent.lowerCase()
		self.userAgent

	getWindowSize: ->
		self=@
		if !self.windowSize?
			self.windowSize =
				width : $(window).width()
				height: $(window).height()
		self.windowSize

	isAndroid: ->
		self=@
		if !self.isAndroid
			self.isAndroid = self.userAgentMatch "android"
		self.isAndroid

	isIpad: ->
		self=@
		if !self.isIpad
			self.isIpad = self.userAgentMatch "ipad"
		self.isIpad

	isIPhone: ->
		self=@
		if !self.isIPhone
			self.isIPhone = self.userAgentMatch "iphone"
		self.isIPhone

	isIPod: ->
		self=@
		if !self.isIPod
			self.isIPod = self.userAgentMatch "ipod"
		self.isIPod

	isIOS: ->
		self=@
		if !self.isIOS
			self.isIOS = self.isIpad() | self.isIPhone() | self.isIPod()
		self.isIOS

	isRetina: ->
		self=@
		if !self.isRetina
			self.isRetina = self.getResolution() == 2
		self.isRetina

	getResolution: ->
		self=@
		if !self.resolution
			self.resolution = window.devicePixelRatio
		self.resolution

	userAgentMatch: (string) ->
		return self.userAgent.indexOf(string) > -1