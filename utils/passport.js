const passport = require('passport')
const mongoose = require('mongoose')
const GoogleStrategy = require('passport-google-oauth20').Strategy
const BearerStrategy = require('passport-http-bearer').Strategy
// eslint-disable-next-line no-unused-vars
const colors = require('colors')
const config = require('../config/secrets.json')

const User = mongoose.model('User')

passport.serializeUser(function (user, done) {
	done(null, user)
})

passport.deserializeUser(function (user, done) {
	User.findOne({
		accessToken: user.accessToken
	}, function (err, user) {
		done(err, user)
	})
})

passport.use(new BearerStrategy(
	function(token, done) {
		User.findOne({
			accessToken: token
		}, function(err, user) {
			if (err) {
				return done(err)
			}

			if (!user) {
				return done(null, false)
			}

			return done(null, user)
		})
	}
))

passport.use(new GoogleStrategy({
	clientID: config.google.clientId,
	clientSecret: config.google.clientSecret,
	callbackURL: config.google.redirectUri
},
function (accessToken, refreshToken, profile, cb) {
	User.findOne({ googleId: profile.id }).exec(function (err, user) {
		if (err) return console.log('ERROR ' + err)
		if (user) {
			console.log('User authenticated ' + `${user.email}`.blue)
			return cb(err, user)
		} else {
			let newUser = new User({
				googleId: profile.id,
				email: profile.emails[0].value,
				name: profile.name.givenName,
				surname: profile.name.familyName,
				picture: profile.photos[0].value
			})
			newUser.generateToken()
			newUser.save(function (err, obj) {
				if (err) {
					console.log('Error saving a new user: '.red + err)
				}
				console.log('New user ' + `${obj.email}`.blue)
				return cb(err, obj)
			})
		}
	})
}))