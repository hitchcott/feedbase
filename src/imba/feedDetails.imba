extern jQuery
extern web3

tag smartInput < input

	def build
		value = object

	def render
		<self>


tag feedDetails

	def onsubmit e
		e.cancel.halt

		if e.target.name is 'setFeedInfo'
			var callParams = [@title.value, @ipfsHash.value]
		else if e.target.name is 'setFeed'
			if var parsedDate = Math.round(Date.new(@expiration.value).getTime()/1000)
				var callParams = [@value.value, parsedDate]
		else if e.target.name is 'setFeedCost'
			var callParams = [@cost.value]
		else if e.target.name is 'transfer'
			var callParams = [@owner.value]

		if callParams
			var params = [object.data:id].concat(callParams).concat({'gas': 3000000})
			object.contract[e.target.name].apply null, params
			console.log e.target.name, params

	def goBack
		up(%app).setFeedId 0

	def canEdit
		object.data:owner is web3:eth:accounts[0]

	def htmlDate date
		if date
			return date.toISOString.slice(0,10)

	def humanDate date
		if date
			date.toLocaleString

	def render
		<self>
			<.btn :click='goBack'> 'Back'
			<br>
			<br>
			<br>
			<.row>
				<.row.wide-section.grey.lighten-4>
					<.col.s12>
						if canEdit
							<h3> "Edit Feed #{object.data:id}"
							<p> 'You are the owner of this feed and can modifying it using the forms below.'
						else
							<h3> "Feed #{object.data:id} Details"
							<p> 'You do not own this feed and cannot modify it.'

				<form.row.wide-section.green.lighten-5 name='setFeedInfo'>
					<.col.s12>
						<i.mdi-action-info-outline.bg-icon.green-text.disabled>
						<h5> 'Feed Info'
						<p> 'Publicly visible metadata'
					<.col.s12.m6>
						<label> 'Feed Name'
						<smartInput@title[object.data:title] type="text" disabled=!canEdit >
					<.col.s12.m6>
						<label> 'Description IPFS Hash'
						<smartInput@ipfsHash[object.data:ipfsHash] type="text" disabled=!canEdit >
					if canEdit
						<button.btn.green.darken-3 type='submit'> 'Update Feed Info'

				<form.row.wide-section.orange.lighten-5 name='setFeed'>
					<.col.s12>
						<i.mdi-communication-message.bg-icon.orange-text>
						<h5> 'Feed Data'
						<p> 'Data made available for a specified duration'
					<.col.m6.s12>
						<label> 'Feed Value'
						<smartInput@value[object.data:value] type="text" disabled=!canEdit >
						if object.data:timestamp
							<p> "Last set: {object.formattedDate('timestamp')}"
					<.col.m6.s12>
						<label> 'Expiry Date'
						<smartInput@expiration[htmlDate(object.data:expiration)] type="date" disabled=!canEdit >
					<.col.s12>
						if canEdit
							<button.btn.orange.darken-3 type='submit'> 'Update Feed Data'

				<form.row.wide-section.light-blue.lighten-5 name='setFeedCost'>
					<.col.s12>
						<i.mdi-editor-attach-money.bg-icon.light-blue-text>
						<h5> 'Fee for First Request'
						<p> 'When another contract gets the data from this feed, a fee must be paid'
					<.col.s12>
						<label> 'Usage Fee in Dai'
						<smartInput@cost[object.data:cost] type="number" disabled=!canEdit >
					<.col.s12>
						if canEdit
							<button.btn.light-blue.darken-3 type='submit'> 'Set Price'

				<form.row.wide-section.purple.lighten-5.last-panel name='transfer'>
					<.col.s12>
						<i.mdi-social-person-add.bg-icon.lighten-5.purple-text>
						<h5> 'Ownership'
						<p> 'Feed data can only be modifid by it\'s owner\'s address'
					<.col.s12>
						<label> 'Owner Address'
						<smartInput@owner[object.data:owner] type="text" disabled=(!canEdit)>
					<.col.s12>
						if canEdit
							<button.btn.purple.darken-3 type='submit'> 'Transfer Owner Address'
