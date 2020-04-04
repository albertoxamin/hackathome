const _ = require('lodash')
const fs = require('fs')

module.exports = function (router, cb) {
	console.log('LOADING controllers...'.yellow)
	fs.readdir('./controllers', function (err, controllers) {
		if (err) {
			console.log('ERROR LOADING CONTROLLERS: '.red + err)
			cb()
		}
		_.each(controllers, function (controller) {
			if (controller === '.DS_Store')
				return
			require('./controllers/' + controller)(router)
			console.log('Controller ' + controller + ' loaded ✓'.green)
		})
		console.log('Controllers loaded successfully! ✓'.green)
		cb()
	})
	require('./utils/passport.js')
}