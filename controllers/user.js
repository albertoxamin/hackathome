const passport = require('passport')
const sanitize = require('../utils/sanitize')
const mongoose = require('mongoose')
const colors = require('colors')

const User = mongoose.model('User')

module.exports = (router) => {
	router
		.route('/user/me')
		.get(
			passport.authenticate('bearer', { session: false }),
			(req, res) => {
				if (req.user) return res.send(sanitize.clean(req.user))
			})
		.post(
			passport.authenticate('bearer', { session: false }),
			(req, res) => {
				if (!req.body ||
					!req.body.homeLocation ||
					!req.body.homeLocation.lat ||
					!req.body.homeLocation.lon)
					return res.status(400).send('Missing parameters')
				User.findById(req.user._id).exec((err, doc) => {
						if (err) return sanitize.cleanError(res, err)
					doc.homeLocation = req.body.homeLocation
					doc.save((err, ok) => {
						if (err) return sanitize.cleanError(res, err)
						return res.status(200).send(sanitize.clean(ok))
					})
				})
			})
}