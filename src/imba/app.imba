extern dapple
extern web3

window:app = undefined

window:onload = do
	window:app = <app>
	($$(#app)).append window:app


class Feed

	prop contract
	prop feed
	prop id
	prop value
	prop owner
	prop timestamp
	prop expiration
	prop cost
	prop paid
	prop title
	prop ipfsHash
	prop transacting

	def initialize contract, id
		@transacting = {}
		@contract = contract
		@id = id
		getData

	def getData
		@feed = contract:feeds.call(id)
		@value = formattedString(contract:get.call(id))
		@owner = feed[0]
		@timestamp = feed[1].toNumber ? Date.new(feed[1].toNumber*1000) : ''
		@expiration = feed[2].toNumber ? Date.new(feed[2].toNumber*1000) : ''
		@cost = feed[3].toNumber
		@paid = feed[4] ? "Yes" : "No"
		@title = formattedString(feed[5])
		@ipfsHash = formattedString(feed[6])

	def editable
		owner is web3:eth:accounts[0]

	def formattedCost
		cost ? "⬙ {cost}" : "Free"

	def formattedDate kind
		this[kind]().toLocaleString

	def formattedString str
		web3.toAscii(str).replace(/\0[\s\S]*$/g,'').trim

	def call kind, args
		var params = [@id].concat(args).concat({'gas': 3000000})
		transacting[kind] = true
		var newTx = @contract[kind].apply null, params
		var interval = setInterval do
			if web3:eth.getTransactionReceipt(newTx)
				clearInterval interval
				transacting[kind] = false
				getData
		, 500

class FeedBase

	prop contract
	prop feeds
	prop transacting

	def initialize web3Contract
		@feeds = {}
		@transacting = {}
		@contract = web3Contract

	def feed id
		# only spawn once
		if !feeds[id]
			feeds[id] = Feed.new(contract, id)

		return feeds[id]

	def feedCount
		contract:claim.call.toNumber()

	def newFeed
		var newTx = contract.claim
		transacting:newFeed = true
		var interval = setInterval do
			if web3:eth.getTransactionReceipt(newTx)
				clearInterval interval
				transacting:newFeed = false
				# go to the newewst item
				window:app.setFeedId feedCount - 1
		, 500

tag app

	prop feedBase
	prop feedId

	def build
		window:feedBase = @feedBase = FeedBase.new(dapple:objects:feedbase)
		@feedId = 0
		schedule

	def setFeedId id
		window.scrollTo 0, 0
		@feedId = id

	def currentFeed
		if @feedId > 0
			return @feedBase.feed(@feedId)
		else
			return false

	def render
		<self>
			<.wrapper>
				<.row>
					<.col.s12.m10.offset-m1.l8.offset-l2>
						<.card-panel.main-panel>
							if currentFeed
								<feedDetails[currentFeed]@{feedId}>
							else
								<.row.wide-section>
									<h1.title-header>
										<img src='https://makerdao.com/splash/images/logo.svg'>
										'Feedbase'
									<p> 'This is a simple data feed contract which lets you publish small pieces of data that can be updated at any time. Each time a feed is updated with a new value you may set an expiration date for that value. You are also able to put a price on your feed which must be paid by the first person who wants to read its value (for each update).'
									<connectionInfo>

								<feedsNav[feedBase]>
