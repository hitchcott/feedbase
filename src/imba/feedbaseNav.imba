tag feedbaseNav

	def claimNew
		object.claim do |err,tx|
			console.log 'done', err, tx

	def setFeedId e
		up(%app).fbId = e.target.value

	def render
		<self>
			<select.browser-default :change='setFeedId'>
				<option> 'Select existing feed'
				for i in [1..object:claim.call.toNumber - 1]
					<option value=i> i + ' - ' + object:feeds.call(i)[0].toString
			<br>
			<.btn :click='claimNew'> 'Claim new feed'


