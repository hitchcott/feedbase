extern dapple

tag app

	def build
		console.log dapple:objects
		schedule

	def render
		<self>
			<img .alt='Maker' src='https://makerdao.com/splash/images/logo.svg'>

window:onload = do
	($$(#app)).append <app>
