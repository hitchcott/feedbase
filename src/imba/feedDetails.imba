extern jQuery

tag feedDetails

	def onsubmit e
		e.cancel.halt

		var formItems = []
		jQuery('input', e.target.dom).each do formItems.push jQuery(this).val

		var callParams = [object:id].concat(formItems)

		up(%app).fbContract[e.target.dom:name].apply null, callParams

	def render
		<self>
			<h3> 'Feed ' + object:id
			<.btn :click='get'> 'Get Value'

			<table>
				<tr>
					<td> 'Onwer'
					<td> object[0]
				<tr>
					<td> 'Updated'
					<td> object[1].toNumber ? Date.new(object[1]*1000).toLocaleString : '-'
				<tr>
					<td> 'Expires'
					<td> object[2].toNumber ? Date.new(object[2]*1000).toLocaleString : '-'
				<tr>
					<td> 'Cost'
					<td> object[3].toNumber ? "{object[3]}" : '-'
				<tr>
					<td> 'Paid'
					<td> object[4] ? 'Yes' : 'No'
			<br>
			<form name='setFeed'>
				<input placeholder='Value'>
				<input placeholder='Date' type='number'>
				# <input placeholder='Expiration Date' type='date'>
				<button.btn type='submit'> 'Set Feed'
			<br>
			<form name='setFeedCost'>
				<input placeholder='Feed Cost' type='number'>
				<button.btn type='submit'> 'Set Feed Cost'
			<br>
			<form name='setFeedCost'>
				<input placeholder='Address'>
				<button.btn type='submit'> 'Transfer Ownership'
