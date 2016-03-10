tag feedbaseNav

	prop contract

	def claimNew
		contract.claim do |err,tx|
			console.log 'done', err, tx

	def setFeedId e
		up(%app).fbId = e.target.value

	def render
		<self>
			<select.browser-default :change='setFeedId'>
				<option> 'Select existing feed'
				for i in [1..contract:claim.call.toNumber - 1]
					<option value=i> i + ' - ' + contract:feeds.call(i)[0].toString
			<br>
			<.btn :click='claimNew'> 'Claim new feed'


