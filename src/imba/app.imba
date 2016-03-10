extern dapple

window:onload = do
	($$(#app)).append <app>

tag app

	prop fbContract
	prop fbId

	def build
		@fbContract = dapple:objects:feedbase
		@fbId = 0
		schedule

	def feed
		var thisFeed = @fbContract:feeds.call(@fbId)
		thisFeed:id = @fbId
		return thisFeed

	def render
		<self>
			<.wrapper>
				<.row>
					<.col.s12.m10.offset-m1.l8.offset-l2>
						<.card-panel>
							<titleHeader>
							<connectionInfo>
							if fbId > 0
								<feedDetails[feed]>
							else
								<feedbaseNav[fbContract]>
