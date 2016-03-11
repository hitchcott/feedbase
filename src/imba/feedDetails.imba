extern jQuery
extern web3

tag smartInput < input

	def build
		value = object

	def render
		<self>


tag ipfsTextarea < textarea

	prop originalText

	def build
		# get IPFS
		value = originalText = 'Some data from IPFS'

	def render
		<self> value


tag feedDetails

	def onsubmit e
		e.cancel.halt

		if e.target.name is 'setFeedInfo'
			# get IPFS hash if the content is different
			if @description.value isnt @description.originalText
				console.log 'changed text'
				@description.originalText = @description.value
			else
				object.call 'setFeedInfo', [@title.value, object.ipfsHash]

		else if e.target.name is 'setFeed'
			if var parsedDate = Math.round(Date.new(@expiration.value).getTime()/1000)
				object.call 'setFeed', [@value.value, parsedDate]

		else if e.target.name is 'setFeedCost'
			object.call 'setFeedCost', [@cost.value]

		else if e.target.name is 'transfer'
			object.call 'transfer', [@owner.value]


	def goBack
		up(%app).setFeedId 0

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
						if object.editable
							<h3> "Edit Feed #{object.id}"
							<p> 'You are the owner of this feed and can modifying it using the forms below.'
						else
							<h3> "Feed #{object.id} Details"
							<p> 'You do not own this feed and cannot modify it.'

				<form.row.wide-section.green.lighten-5 name='setFeedInfo'>
					<.col.s12>
						<i.mdi-action-info-outline.bg-icon.green-text>
						<h5> 'Feed Info'
						<p> 'Publicly visible meta data'
					<.col.s12>
						<label> 'Feed Name'
						<smartInput@title[object.title] type="text" disabled=!object.editable>
					<.col.s12>
						<label> 'Description'
						<ipfsTextarea@description[object.ipfsHash].materialize-textarea disabled=!object.editable>
					if object.editable
						<button.btn.green.darken-3 type='submit'> 'Update Feed Info'

				<form.row.wide-section.orange.lighten-5 name='setFeed'>
					<.col.s12>
						<i.mdi-communication-message.bg-icon.orange-text>
						<h5> 'Feed Data'
						<p> 'Data made available for a specified duration'
					<.col.m6.s12>
						<label> 'Feed Value'
						<smartInput@value[object.value] type="text" disabled=!object.editable>
						if object.timestamp
							<p> "Last set: {object.formattedDate('timestamp')}"
					<.col.m6.s12.input-field>
						<label> 'Expiry Date'
						<smartInput@expiration[htmlDate(object.expiration)] type="date" disabled=!object.editable>
					<.col.s12>
						if object.editable
							<button.btn.orange.darken-3 type='submit'> 'Update Feed Data'

				<form.row.wide-section.light-blue.lighten-5 name='setFeedCost'>
					<.col.s12>
						<i.mdi-editor-attach-money.bg-icon.light-blue-text>
						<h5> 'Fee for First Request'
						<p> 'When another contract gets data from this feed, a fee must be paid'
					<.col.s12>
						<label> 'Usage Fee in Dai'
						<smartInput@cost[object.cost] type="number" disabled=!object.editable>
					<.col.s12>
						if object.editable
							if object.transacting:setFeedCost
								<p> 'TX Pending...'
							else
								<button.btn.light-blue.darken-3 type='submit'> 'Set Price'

				<form.row.wide-section.purple.lighten-5.last-panel name='transfer'>
					<.col.s12>
						<i.mdi-social-person-add.bg-icon.lighten-5.purple-text>
						<h5> 'Ownership'
						<p> 'Feed can only be modifid by it\'s owner\'s address'
					<.col.s12>
						<label> 'Owner Address'
						<smartInput@owner[object.owner] type="text" disabled=!object.editable>
					<.col.s12>
						if object.editable
							<button.btn.purple.darken-3 type='submit'> 'Transfer Owner Address'
