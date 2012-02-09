class exports.DynamicScreenHelper
	# dependencies: DeviceHelper

	@tag              = "DynamicScreenHelper"
	@baseWindowSize   = {}
	@baseItemSize     = {}
	@scaleFontSize    = 1
	@itemScale        = 1
	@itemPaddingStyle = ""

	@initialize = (config) ->
		@configure config
		@refreshWindow()
		@generateItemPaddingStyle()

	@configure = (config) ->
		@baseWindowSize = config.baseWindowSize
		@baseItemSize   = config.baseItemSize
		@scaleFontSize  = config.scaleFontSize

	@refreshWindow = ->
		$body = $("body") # cache element

		proportionalSize = @getProportionalSize DeviceHelper.getWindowSize(), @baseWindowSize
		$body.width(proportionalSize.width).height(proportionalSize.height)

		$body.css 'font-size', (proportionalSize.width * @scaleFontSize) + '%' # adapt font-size

	@generateItemPaddingStyle = ->
		bodySize = @getElementSize $('body')

		paddingItemImage = 2

		# TODO: find a way to not use that
		itemPaddingElementDefaultSize =
			width : bodySize.width * .50 - 2 * paddingItemImage
			height: bodySize.height * .85 - 2 * paddingItemImage

		proportionalSize = @getProportionalSize itemPaddingElementDefaultSize, @baseItemSize

		@itemScale = proportionalSize.ratio

		differenceWidth = itemPaddingElementDefaultSize.width - proportionalSize.width
		differenceHeight = itemPaddingElementDefaultSize.height - proportionalSize.height

		position =
			left: paddingItemImage
			top : paddingItemImage

		position.left += differenceWidth / 2 if differenceWidth > 0
		position.top  += differenceHeight / 2 if differenceHeight > 0

		@itemPaddingStyle  = "top: " + position.top + "px;"
		@itemPaddingStyle += "bottom: " + position.top + "px;"
		@itemPaddingStyle += "left: " + position.left + "px;"
		@itemPaddingStyle += "right: " + position.left + "px;"

		@itemPaddingStyle

	@getProportionalSize = (size, baseSize) ->
		ratioWidth  = size.width / baseSize.width
		ratioHeight = size.height / baseSize.height

		proportionalSize = baseSize

		if ratioHeight > ratioWidth
			proportionalSize.width  = size.width
			proportionalSize.height *= ratioWidth
			proportionalSize.ratio  = ratioWidth
		else
			proportionalSize.height = size.height
			proportionalSize.width  *= ratioHeight
			proportionalSize.ratio  = ratioHeight

		proportionalSize

	@getElementSize = ($element) ->
		new Object
			width : $element.width()
			height: $element.height()