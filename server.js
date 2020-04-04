const express = require('express')
const passport = require('passport')
const bodyParser = require('body-parser')
const morgan = require('morgan')
const fs = require('fs')
const colors = require('colors')
const _ = require('lodash')
const mongoose = require('mongoose')
const secrets = require('./config/secrets.json')

var app

console.log('|----------------------|'.bgRed)
console.log('|--  '.bgRed + ' HACK AT HOME '.bgWhite.black + '  --|'.bgRed)
console.log('|----------------------|'.bgRed)

fs.readdir('./models', function (err, models) {
	console.log('LOADING Models...'.yellow)
	if (err) {
		console.log('ERROR LOADING MODELS: '.red + err)
	}
	_.each(models, function (model) {
		if (model === '.DS_Store')
			return
		require('./models/' + model)
		console.log('Model ' + model + ' loaded ✓'.green)
	})
	console.log('Models loaded successfully! ✓'.green)

	console.log('LOADING Express...'.yellow)
	app = express()
	var router = express.Router()
	app.use(bodyParser.json())
	app.use(passport.initialize())
	app.use(passport.session())
	app.use(morgan('dev'))
	app.use('/', router)
	require('./router.js')(router, function () {
		console.log('Express loaded successfully! ✓'.green)

		console.log('CONNECTING to mongodb...'.yellow)
		mongoose.connection.on('open', function () {
			console.log('Connected to the database! ✓'.green)
			app.listen(6600)
			console.log('listening on http://localhost:6600'.green)
		})

		mongoose.connection.on('error', function () {
			console.log('DATABASE CONNECTION ERROR! ⚠'.red)
		})

		mongoose.connect(secrets.mongodb.uri, { useNewUrlParser: true })
		mongoose.set('useCreateIndex', true)
	})
})