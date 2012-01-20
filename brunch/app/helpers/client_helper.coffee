class exports.ClientHelper
	tag        : "ClientHelper"
	_userAgent : null
	_windowSize: null
	_isMobile  : null
	_isAndroid : null
	_isIOS     : null
	_isIpad    : null
	_isIPhone  : null
	_isIPod    : null
	_isRetina  : null
	_resolution: null

	constructor: ->
		self=@
		self

	getUserAgent: ->
		self=@
		if !self._userAgent?
			self._userAgent = navigator.userAgent.toLowerCase()

		self._userAgent

	getWindowSize: ->
		self=@
		if !self._windowSize?
			self._windowSize =
				width : $(window).width()
				height: $(window).height()
		self._windowSize

	isMobile: ->
		self=@
		if !self._isMobile
			self._isMobile = self.isAndroid() | self.isIOS()
		self._isMobile

	isAndroid: ->
		self=@
		if !self._isAndroid
			self._isAndroid = self.userAgentMatch "android"
		self._isAndroid

	isIOS: ->
		self=@
		if !self._isIOS
			self._isIOS = self.isIpad() | self.isIPhone() | self.isIPod()
		self._isIOS

	isIpad: ->
		self=@
		if !self._isIpad
			self._isIpad = self.userAgentMatch "ipad"
		self._isIpad

	isIPhone: ->
		self=@
		if !self._isIPhone
			self._isIPhone = self.userAgentMatch "iphone"
		self._isIPhone

	isIPod: ->
		self=@
		if !self._isIPod
			self._isIPod = self.userAgentMatch "ipod"
		self._isIPod

	isIOS: ->
		self=@
		if !self._isIOS
			self._isIOS = self.isIpad() | self.isIPhone() | self.isIPod()
		self._isIOS

	isRetina: ->
		self=@
		if !self._isRetina
			self._isRetina = self.getResolution() == 2
		self._isRetina

	getResolution: ->
		self=@
		if !self._resolution
			self._resolution = window.devicePixelRatio | 1

		self._resolution

	userAgentMatch: (string) ->
		return @getUserAgent().indexOf(string) > -1