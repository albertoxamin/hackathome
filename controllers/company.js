const passport = require('passport')
const sanitize = require('../utils/sanitize')
const mongoose = require('mongoose')
const colors = require('colors')

const Company = mongoose.model('Company')
const Good = mongoose.model('Good')

module.exports = (router) => {
	router
		.route('/company')
		.get(
			passport.authenticate('bearer', { session: false }),
			(req, res) => {
				Company.find({ owner: req.user._id }).lean().exec(function (err, companys) {
					if (err) return sanitize.cleanError(res, err)
					if (companys) return res.send(sanitize.clean(companys))
				})
			})
		.post(
			passport.authenticate('bearer', { session: false }),
			(req, res) => {
				if (!req.body ||
					!req.body.location ||
					!req.body.name ||
					!req.body.logo ||
					!req.body.description)
					return res.status(400).send('Missing parameters')
				let newcompany = new Company({
					owner: req.user._id,
					name: req.body.name,
					location: req.body.location,
					logo: req.body.logo,
					description: req.body.description,
				})
				newcompany.save(function (err, company) {
					if (err) sanitize.cleanError(res, err)
					if (company) return res.send(sanitize.clean(company))
				})
			}),
		router
			.route('/company/:id')
			.get(
				passport.authenticate('bearer', { session: false }),
				(req, res) => {
					Company.findOne({ _id: req.params.id }).populate({ path: 'owner' }).lean().exec(function (err, companys) {
						if (err) return sanitize.cleanError(res, err)
						if (companys) {
							sanitize.cleanUser(companys.owner)
							return res.send(sanitize.clean(companys))
						}
					})
				}),
		router
			.route('/company/:id/good')
			.get(
				passport.authenticate('bearer', { session: false }),
				(req, res) => {
					Company.findOne({ _id: req.params.id }).populate({ path: 'goods' }).lean().exec(function (err, companys) {
						if (err) return sanitize.cleanError(res, err)
						if (companys) {
							return res.send(sanitize.clean(companys.goods))
						}
					})
				})
			.post(
				passport.authenticate('bearer', { session: false }),
				(req, res) => {
					if (!req.body ||
						!req.body.name ||
						!req.body.description ||
						!req.body.volume)
						return res.status(400).send('Missing parameters')
					Company.findOne({ _id: req.params.id }).populate({ path: 'goods' }).exec(function (err, company) {
						if (err) return sanitize.cleanError(res, err)
						if (company) {
							let newGood = new Good({
								picture: req.body.picture,
								quantity: req.body.quantity,
								name: req.body.name,
								volume: req.body.volume,
								description: req.body.description,
							})
							newGood.save(function (err, good) {
								if (err) sanitize.cleanError(res, err)
								if (good) {
									company.goods.push(good)
									company.save()
									return res.send(sanitize.clean(company))
								}
							})
						} else {
							return res.status(404).send('company not found')
						}
					})
				})

	router
		.route('/company/:id/good/:goodId')
		.delete(
			passport.authenticate('bearer', { session: false }),
			(req, res) => {
				Company.findOne({ _id: req.params.id }).populate({ path: 'goods' }).populate('owner').exec(function (err, company) {
					if (err) return sanitize.cleanError(res, err)
					if (company) {
						if (!company.owner.equals(req.user))
							return res.status(401).send()
						Good.findOne({ _id: req.params.goodId }).exec(function (err, good) {
							if (err) return sanitize.cleanError(res, err)
							if (!good)
								return res.status(404).send()
							company.goods.remove(good)
							company.save()
							good.remove()
							good.save()
							return res.status(200).send()
						})
					}
				})
			})

	router
		.route('/company/:id')
		.delete(
			passport.authenticate('bearer', { session: false }),
			(req, res) => {
				Company.findOne({ _id: req.params.id }).populate({ path: 'owner' }).exec(function (err, company) {
					if (err) return sanitize.cleanError(res, err)
					if (company) {
						console.log(req.user)
						console.log(company.owner)
						if (!company.owner.equals(req.user))
							return res.status(401).send()
						console.log('Company deleted ' + `${company._id}`.red)
						company.remove()
						return res.status(200).send()
					}
					return res.status(400).send()
				})
			})
}