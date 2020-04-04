const passport = require('passport')
const sanitize = require('../utils/sanitize')
const mongoose = require('mongoose')

const Order = mongoose.model('Order')
const Company = mongoose.model('Company')
const Good = mongoose.model('Good')

module.exports = (router) => {
	router
		.route('/order')
		.get(
			passport.authenticate('bearer', { session: false }),
			(req, res) => {
				Order.find({ 'customer': req.user._id }).populate('goods').lean().exec((err, docs) => {
					if (err) return sanitize.cleanError(res, err)
					return res.status(200).send(sanitize.clean(docs))
				})
			})
		.post(
			passport.authenticate('bearer', { session: false }),
			(req, res) => {
				if (!req.body ||
					!req.body.companyId ||
					!req.body.goods)
					return res.status(400).send('Missing parameters')
				Company.findOne({ '_id': req.body.companyId }, (err, cmp) => {
					if (err) return sanitize.cleanError(res, err)
					Good.find({ '_id': { $in: req.body.goods.map(x => x.item) } }, (err, goods) => {
						if (err) return sanitize.cleanError(res, err)
						let order = new Order({
							company: cmp,
							customer: req.user,
							goods: goods.map(x => {
								return {
									item: x,
									quantity: req.body.goods.find(g => g.item == x._id).quantity
								}
							})
						})
						order.save((err, doc) => {
							if (err) return sanitize.cleanError(res, err)
							doc = sanitize.clean(doc)
							doc.goods = sanitize.clean(doc.goods)
							doc.customer = sanitize.cleanUser(doc.customer)
							doc.company = sanitize.clean(doc.company)
							return res.send(doc)
						})
					})
				})
			})
}