extern dapple
extern web3

window:onload = do
	($$(#app)).append <app>


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
		console.log 'initialized'

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
		@contract[kind].apply null, params
		@transacting[kind] = true
		console.log kind, params
		# TODO keep track of transaction
		# getData when transaction is complete


class FeedBase

	prop contract
	prop feeds

	def initialize web3Contract
		@feeds = {}
		@contract = web3Contract

	def feed id
		# only spawn once
		if !feeds[id]
			feeds[id] = Feed.new(contract, id)

		return feeds[id]

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
							<.row.wide-section>
								<h1.title-header>
									<img src='https://makerdao.com/splash/images/logo.svg'>
									'Feedbase'
								<p> 'This is a simple data feed contract which lets you publish small pieces of data that can be updated at any time. Each time a feed is updated with a new value you may set an expiration date for that value. You are also able to put a price on your feed which must be paid by the first person who wants to read its value (for each update).'
								<connectionInfo>
							if currentFeed
								<feedDetails[currentFeed]@{feedId}>
							else
								<feedsNav[feedBase]>
