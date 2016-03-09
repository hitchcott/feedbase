extern dapple

tag app

	def build
		console.log dapple:objects
		schedule

	def render
		<self>
			<h1> 'Materialized'
			<img .alt='Maker' src='https://makerdao.com/splash/images/logo.svg'>
			<div.btn> 'test'

window:onload = do
	($$(#app)).append <app>
