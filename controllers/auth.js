const passport = require('passport')
const sanitize = require('../utils/sanitize')

module.exports = (router) => {
	router
		.route('/auth/google')
		.get(passport.authenticate('google', { scope: ['profile', 'email'] }))

	router
		.route('/auth/google/callback')
		.get(
			passport.authenticate('google', { failureRedirect: '/auth' }),
			(req, res) => {
				return res.send(sanitize.clean(req.user))
			}
		)

	router
		.route('/')
		.get(
			passport.authenticate('bearer', { session: false }),
			(req, res) => {
				return res.send('uuu nice user')
			}
		)
}