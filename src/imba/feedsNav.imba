extern web3

tag feedsNav

	def claimNew
		object.contract.claim
		# TODO listen for updates

	def feedItems
		var items = []
		var totalItems = object.contract:claim.call().toNumber()
		for i in [totalItems - 5 ... totalItems]
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
		if object.editable
			up(%app).setFeedId object.id

	def render
		<self.collection-item :click='setFeedId' .editable=object.editable>
			<table.feed-info-table.highlight>
				<tr>
					<th> "#{object.id}"
					<th> object.title
				<tr>
					<td> 'Owner'
					<td.hilight-editable>
						object.owner
						if object.editable
							' (You)'
				<tr>
					<td> 'Value'
					<td> object.value
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
					<td> object.paid

