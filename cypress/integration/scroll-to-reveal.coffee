context 'Scroll to reveal story', ->

	beforeEach -> 
		cy.viewport 800, 800
		cy.visit '?path=/story/examples--scroll-to-reveal'
		cy.wait 1500 # Wait for iframe to load

	it 'is initially hidden', -> 
		cy.checkState 
			now:   false
			fully: false
			above: false
			below: true
	
	it 'is visible after 1px of scroll', -> 
		cy.scroll 1
		cy.checkState 
			now:   true
			fully: false
			above: false
			below: true
	
	it 'is fully visible after scrolling the box height (200px)', -> 
		cy.scroll 200
		cy.checkState 
			now:   true
			fully: true
			above: false
			below: false
	
	it 'is still fully visible after scrolling 100vh', -> 
		cy.getHeight (height) ->
			cy.scroll height
			cy.checkState 
				now:   true
				fully: true
				above: false
				below: false
	
	it 'is still no longer fully visible after 1 more px of scroll', -> 
		cy.getHeight (height) ->
			cy.scroll height + 1
			cy.checkState 
				now:   true
				fully: false
				above: true
				below: false
	
	it 'is fully hidden after scrolling 100vh plus box height', -> 
		cy.getHeight (height) ->
			cy.scroll height + 200
			cy.checkState 
				now:   false
				fully: false
				above: true
				below: false
		
# Helper to check boolean-ish values
checkState = (state) ->
	
	# Find the component iframe
	cy.get('#storybook-preview-iframe').then (iframe) ->
		$doc = iframe.contents()
		for key,val of state
			cy.wrap $doc.find "[data-cy=#{key}]"
			.should 'have.text', if val then 'Yes' else 'No'
		return