root=@

class exports.BenchmarkHelper
	self=@

	self.frequence = 10
	self.finished = false
	self.tests = [
		'move'
		'move_resize'
		'fade'
		'pop'
	]
	self.currentTest = 0
	self.updates = []
	self.onOver = null

	self.test = (callback) ->
		@onOver = callback if callback?
		@update()
		@startTest()

	self.startTest = ->
		testName = ("benchmark_test_" + @tests[@currentTest]).toPascalCase()
		test = new (eval(testName))()
		test.onFinish = => @endTest()
		test.start()

	self.endTest = ->
		if @currentTest >= @tests.length - 1
			self.finish()
		else
			@currentTest++
			self.startTest()

	self.update = ->
		if not @finished
			@updates.push app.helpers.countdown.now()
			setTimeout((=> @update()), @frequence)

	self.finish = ->
		total = 0
		@finished = true

		i = l = @updates.length - 1
		while i-- and last = @updates.pop()
			dif = last - @updates[i]
			total += dif - @frequence

		# reset
		@updates = []
		@currentTest = 0

		# average of the time between frames
		average = total / l

		# generate a grade
		getGrade = (average) =>
			if average < 5
				1
			else if average < 10
				2
			else 3

		console.log "benchmark result: " + average
		grade = getGrade(average)
		console.log "animation grade received: " + grade

		@onOver(grade) if @onOver?

class BenchmarkTest
	onFinish: null
	finished: false

	finish: -> @onFinish() if @onFinish?

class BenchmarkTestMove extends BenchmarkTest
	start: ->
		div = $("<div />").css({
			width: "50px"
			height: "50px"
			position: "absolute"
			top: 0
			left: 0
		})

		div.appendTo("body").animate {
			left: "100%"
			top: "100%"
		}, {
			duration: 200
			complete: =>
				div.remove()
				@finish()
		}

class BenchmarkTestMoveResize extends BenchmarkTest
	start: ->
		div = $("<div />").css({
			width: "50px"
			height: "50px"
			position: "absolute"
			top: 0
			left: 0
		})

		div.appendTo("body").animate {
			left: "100%"
			top: "100%"
			width: "400px"
			height: "500px"
		}, {
			duration: 200
			complete: =>
				div.remove()
				@finish()
		}

# TODO:class BenchmarkTestCSS3Animation extends BenchmarkTest

class BenchmarkTestFade extends BenchmarkTest
	start: ->
		div = $("<div />").css({
			width: "50px"
			height: "50px"
			position: "absolute"
			top: 0
			left: 0
			opacity: 0
		})

		div.appendTo("body").fadeIn 50, =>
			div.fadeOut 50, =>
				div.fadeIn 50, =>
					div.fadeOut 50, =>
						div.remove()
						@finish()

class BenchmarkTestPop extends BenchmarkTest
	start: ->
		div = $("<div />").css({
			width: "50px"
			height: "50px"
			position: "absolute"
			top: "100px"
			left: "100px"
		})

		div.appendTo("body").popIn 1000, =>
			div.popOut 1000, =>
				div.popIn 1000, =>
					div.popOut 1000, =>
						div.remove()
						@finish()
