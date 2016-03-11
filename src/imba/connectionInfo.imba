extern web3
extern dapple

tag connectionInfo < table
	def render
		var ethStats = [
			[
				text: 'Your Account'
				value: web3:eth:accounts[0]
			,
				text: 'Contract Address'
				value: dapple:objects:feedbase:address
			]
			[
				text: 'Latest Block'
				value: """
				#{web3:eth:blockNumber} :
				{Date.new(web3:eth.getBlock(web3:eth:blockNumber):timestamp*1000).toLocaleString}
				"""
			,
				text: 'Hashrate'
				value: web3:eth:hashrate
			,
				text: 'Balance'
				value: "{web3:fromWei(web3:eth:getBalance(web3:eth:accounts[0]),'ether')}"
			],
		]


		<self>
			<table.connection-info>
				<tbody>
					<tr>
						for stat in ethStats[0]
							<statCell[stat]>

			<table.connection-info>
				<tbody>
					<tr>
						for stat in ethStats[1]
							<statCell[stat]>


tag statCell < td
	def render
		<self>
			<b> object:text + " "
			<br>
			object:value
