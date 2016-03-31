###
Determines if the view is in visible in the browser window.

Example usage:
	Just require the mixin from your component.
	Use the optional offset props like:

	large-copy(
		:in-viewport-offset-top="300"
		:in-viewport-offset-bottom="0.5"

		# Only add the `in-viewport` class once per page load
		:in-viewport-once="false"
	)

###

# Deps
win = require 'window-event-mediator'
visibility = require './visibility'

# Mixin definiton
module.exports =

	# Settings
	props:

		# Add listeners and check if in viewport immediately
		inViewportActive:
			type: 'Boolean'
			default: true

		# Whether to only update in-viewport class once
		inViewportOnce:
			type: 'Boolean'
			default: true

		# Whether to only update in-viewport class once
		inViewportClass:
			type: 'string'
			default: 'in-viewport'

		# Whether to only update in-viewport class once
		inViewportEntrelyClass:
			type: 'string'
			default: 'in-viewport-entirely'

		# A positive offset triggers "late" when scrolling down
		inViewportOffsetTop:
			type: Number
			default: 0

		# A negative offset triggers "early" when scrolling down
		inViewportOffsetBottom:
			type: Number
			default: 0

	# Boolean stores whether component is in viewport
	data: ->
		inViewport: false
		inViewportEntirely: false

	# Add handlers when vm is added to dom unless init is false
	ready: -> @addInViewportHandlers() if @inViewportActive

	# If comonent is destroyed, clean up listeners
	destroyed: -> @removeInViewportHandlers()

	# Vars to watch
	watch:

		# Adds handlers if they weren't added at runtime
		inViewportActive: (ready) ->
			@addInViewportHandlers() if ready

		# Adds the `in-viewport` class when the component is in bounds/
		inViewport: (visible) ->
			@removeInViewportHandlers() if @inViewportOnce and visible
			$(@$el).toggleClass(@inViewportClass, visible) if @inViewportClass

		inViewportEntirely: (visible) ->
			$(@$el).toggleClass(@inViewportEntrelyClass, visible) if @inViewportEntrelyClass


	# Public API
	methods:

		# Update viewport status on scroll
		onInViewportScroll: ->
			@inViewport =   @isInViewport @$el,
				offsetTop:    @inViewportOffsetTop
				offsetBottom: @inViewportOffsetBottom
			@inViewportEntirely = @isInViewportEntirely @$el

		# Add listeners
		addInViewportHandlers: ->
			return if @inViewportHandlersAdded
			@inViewportHandlersAdded = true
			win.on 'scroll', @onInViewportScroll
			win.on 'resize', @onInViewportScroll
			@onInViewportScroll()

		# Remove listeners
		removeInViewportHandlers: ->
			return unless @inViewportHandlersAdded
			@inViewportHandlersAdded = false
			win.off 'scroll', @onInViewportScroll
			win.off 'resize', @onInViewportScroll

		# Public API for invoking visibility tests
		
		# Check if the element is visible at all in the viewport
		isInViewport: (el, options) -> visibility.isInViewport(el, options)

		# Check if the elemetn is entirely visible in the viewport
		isInViewportEntirely: (el, options) -> visibility.isFullyVisible el
