extern jQuery
extern web3


tag feedDetails

	prop feed
	prop contract

	def onsubmit e
		e.cancel.halt

		var formItems = []
		jQuery('input', e.target.dom).each do formItems.push jQuery(this).val

		var callParams = [feed:id].concat(formItems).concat({'gas': 3000000})

		contract[e.target.dom:name].apply null, callParams

	def goBack
		up(%app).fbId = 0

	def getValue
		contract.get feed:id

	def render
		<self>
			<.btn :click='goBack'> 'Back'
			if web3.toAscii(feed[5])
				<h4> web3.toAscii(feed[5])

			if !feed[4] and feed[3].toNumber
				<.btn :click='getValue'> "Get Value - {feed[3]} DAI"

			<table>
				<tr>
					<td> 'id'
					<td> feed:id
				<tr>
					<td> 'Value'
					<td> web3.toAscii(contract:get.call(feed:id))
				<tr>
					<td> 'Onwer'
					<td> feed[0]
				<tr>
					<td> 'Updated'
					<td> feed[1].toNumber ? Date.new(feed[1]*1000).toLocaleString : '-'
				<tr>
					<td> 'Expires'
					<td> feed[2].toNumber ? Date.new(feed[2]*1000).toLocaleString : '-'
				<tr>
					<td> 'Cost'
					<td> feed[3].toNumber ? feed[3].toNumber : '-'
				<tr>
					<td> 'Paid'
					<td> feed[4] ? 'Yes' : 'No'
			<br>
			<form name='setFeed'>
				<input placeholder='Value'>
				<input placeholder='Date' type='number'>
				<input placeholder='Name (Public)'>
				<button.btn type='submit'> 'Set Feed'
			<br>
			<form name='setFeedCost'>
				<input placeholder='Feed Cost' type='number'>
				<button.btn type='submit'> 'Set Feed Cost'
			<br>
			<form name='transfer'>
				<input placeholder='Address'>
				<button.btn type='submit'> 'Transfer Ownership'
