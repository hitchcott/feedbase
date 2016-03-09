extern web3
extern dapple

tag connectionInfo < table
	def render
		var ethStats = [
			text: 'Block #'
			value: web3:eth:blockNumber
		,
			text: 'Hashrate'
			value: web3:eth:hashrate
		,
			text: 'Balance'
			value: "{web3:fromWei(web3:eth:getBalance(web3:eth:accounts[0]),'ether')}"
		,
			text: 'Account '
			value: web3:eth:accounts[0]
		,
			text: 'Contract '
			value: dapple:objects:feedbase:address
		]

		<self.connection-info>
			<tbody>
				<tr>
					for stat in ethStats
						<statCell[stat]>

tag statCell < td
	def render
		<self>
			<b> object:text + " "
			<br>
			object:value
