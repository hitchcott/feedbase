tag feedbaseNav

	def claimNew
		object.claim do |err,tx|
			console.log 'done', err, tx

	def render
		<self>
			<.btn :click='claimNew'> 'Claim new feed'
			<br>
			<ul>
			for i in [0..object:claim.call.toNumber]
				<li> i


