class exports.DeviceHelper
	self=@

	self.tag          = "DeviceHelper"
	self._userAgent   = null
	self._windowSize  = null
	self._isMobile    = null
	self._isAndroid   = null
	self._isIOS       = null
	self._isIpad      = null
	self._isIPhone    = null
	self._isIPod      = null
	self._isRetina    = null
	self._resolution  = null
	self._localization= null

	self.getWindowSize = ->
		self._windowSize ?= {width : $(window).width(), height: $(window).height()}

	self.isMobile = ->
		self._isMobile ?= self.isAndroid() or self.isIOS()

	self.isAndroid = ->
		self._isAndroid ?= self.userAgentMatch "android"

	self.isIOS = ->
		self._isIOS ?= self.isIpad() or self.isIPhone() or self.isIPod()

	self.isIpad = ->
		self._isIpad ?= self.userAgentMatch "ipad"

	self.isIPhone = ->
		self._isIPhone ?= self.userAgentMatch "iphone"

	self.isIPod = ->
		self._isIPod ?= self.userAgentMatch "ipod"

	self.isIOS = ->
		self._isIOS ?= self.isIpad() or self.isIPhone() or self.isIPod()

	self.isRetina = ->
		self._isRetina ?= self.getResolution() == 2

	self.getResolution = ->
		self._resolution ?= window.devicePixelRatio or 1

	self.getLocalization = ->
		self._localization ?= navigator.language.substr(0, 2)

	self.userAgentMatch = (string) ->
		self.getUserAgent().indexOf(string) > -1

	self.getUserAgent = ->
		self._userAgent ?= navigator.userAgent.toLowerCase()