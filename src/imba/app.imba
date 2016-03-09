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

	def render
		<self>
			<.wrapper>
				<.row>
					<.col.s12.m8.offset-m2.l6.offset-l3>
						<.card-panel>
							<titleHeader>
							<connectionInfo>
							if fbId > 0
								<feedbaseDetails>
							else
								<feedbaseNav[fbContract]>
