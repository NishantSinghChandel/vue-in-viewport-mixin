context 'Trigger late story', ->

	beforeEach -> 
		cy.viewport 800, 800
		cy.visit '?path=/story/examples--trigger-late-px'
		cy.wait 1500 # Wait for iframe to load

	it 'is initially hidden', -> 
		cy.checkState 
			now:   false
			fully: false
			above: false
			below: true
	
	it 'is not visible after 1px of scroll', -> 
		cy.scroll 1
		cy.checkState 
			now:   false
			fully: false
			above: false
			below: true
	
	it 'becomes visible after 20px of scroll', -> 
		cy.scroll 20
		cy.checkState 
			now:   true
			fully: false
			above: false
			below: true
	
	it 'becomes fully visible after 220px of scroll', -> 
		cy.scroll 220
		cy.checkState 
			now:   true
			fully: true
			above: false
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