extern dapple
extern web3

window:onload = do
	($$(#app)).append <app>


class Feed

	prop feed
	prop data
	prop contract

	def formattedCost
		@data:cost ? "⬙ {@data:cost}" : "Free"

	def formattedDate kind
		@data[kind] ? @data[kind].toLocaleString : ""

	def formattedString str
		web3.toAscii(str).replace(/\0[\s\S]*$/g,'').trim

	def initialize contract, id
		@contract = contract
		@feed = contract:feeds.call(id)
		@data = {
			id: id
			value: formattedString(contract:get.call(id))
			owner: feed[0]
			timestamp: feed[1].toNumber ? Date.new(feed[1].toNumber*1000) : 0
			expiration: feed[2].toNumber ? Date.new(feed[2].toNumber*1000) : 0
			cost: feed[3].toNumber
			paid: feed[4] ? "Yes" : "No"
			title: formattedString(feed[5])
			ipfsHash: formattedString(feed[6])
		}

class FeedBase

	prop contract

	def initialize web3Contract
		@contract = web3Contract

	def feed id
		Feed.new(contract, id)

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
							<titleHeader>
							if currentFeed
								<connectionInfo>
								<feedDetails[currentFeed]@{feedId}>
							else
								<p> 'This is a simple data feed contract which lets you publish small pieces of data that can be updated at any time. Each time a feed is updated with a new value you may set an expiration date for that value. You are also able to put a price on your feed which must be paid by the first person who wants to read its value (for each update).'
								<connectionInfo>
								<feedsNav[feedBase]>
