extern web3

tag feedbaseNav

	prop contract

	def claimNew
		var tx = contract.claim
		# TODO listen for updates

	def setFeedId e
		up(%app).fbId = e.target.value

	def render
		<self>
			<select.browser-default :change='setFeedId'>
				<option> 'Select existing feed'
				for i in [1..contract:claim.call.toNumber - 1]
					<option value=i> "[{i}] {web3.toAscii(contract:feeds.call(i)[5]) || "Untitled"}"
			<br>
			<.btn :click='claimNew'> 'Claim new feed'


