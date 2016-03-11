extern web3

tag feedsNav

	def claimNew
		object.contract.claim
		# TODO listen for updates

	def feedItems
		var items = []
		for i in [1...object.contract:claim.call().toNumber()]
			items.unshift(object.feed(i))
		return items

	def render
		<self>
			<.btn :click='claimNew'> 'Claim new feed'
			<br>
			<br>
			if feedItems:length
				<ul.collection.feed-items>
					for item in feedItems
						<feedItem[item]>
			else
				<p> 'No Feeds'


tag feedItem < li

	def setFeedId
		up(%app).setFeedId object.data:id

	def render
		var data = object.data
		<self.collection-item :click='setFeedId'>
			<table.feed-info-table.highlight>
				<tr>
					<th> "#{data:id}"
					<th> data:title
				<tr>
					<td> 'Owner'
					<td> data:owner
				<tr>
					<td> 'Value'
					<td> data:value
				<tr>
					<td> 'Updated'
					<td> object.formattedDate('timestamp')
				<tr>
					<td> 'Expires'
					<td> object.formattedDate('expiration')
				<tr>
					<td> 'Usage Fee'
					<td> object.formattedCost
				<tr>
					<td> 'Paid'
					<td> data:paid

