extern web3

tag feedsNav

	def claimNew
		object.newFeed

	def feedItems
		var items = []
		var totalItems = object.feedCount
		var minimum = if (totalItems - 5 < 1) then 1 else (totalItems - 5)
		for i in [minimum ... totalItems]
			items.unshift(object.feed(i))
		return items

	def render
		<self>
			<.row>
				<.row.wide-section.grey.lighten-4.last-panel>
					<.col.s12>
						if !object.transacting:newFeed
							<.btn.right :click='claimNew'> 'Claim new feed'
						else
							<txPendingSpinner.right>

						<h3> 'Feed List'
						<p> 'If you are an owner of any of the feeds below you can click it to update it\'s details.'
						if feedItems:length
							<br>
							<ul.collection.feed-items>
								for item in feedItems
									<feedItem[item]>

							# <.row.wide-section.grey.lighten-3.last-panel>
							# 	<.col.s12>
							# 		<p> 'Todo navigation'
						else
							<p.center-align> 'No Feeds Registered'


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

