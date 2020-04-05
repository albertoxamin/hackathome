const colors = require('colors')
const _ = require('lodash')

const clean = (obj, req) => {
	try {
		obj = obj.toObject()
	} catch (err) { }
	if (Array.isArray(obj)) {
		_.map(obj, clean)
		return obj
	}
	obj.id = obj._id.toString()
	delete obj._id
	delete obj.__v
	delete obj.createdAt
	delete obj.updatedAt
	return obj
}

const cleanError = (res, err) => {
	console.log('500 '.red + err.message)
	res.status(500).send(err.message)
}

const cleanUser = (user, keepAddress = false) => {
	let obj = clean(user)
	delete user.googleId
	delete user.accessToken
	if (!keepAddress)
		delete user.homeLocation
	delete user.email
	delete user.id
	return obj
}

const cleanOrder = (ord) => {
	let obj = clean(ord)
	obj.goods = obj.goods.map(x => clean(x))
	return obj
}

module.exports = {
	clean: clean,
	cleanError: cleanError,
	cleanUser: cleanUser,
	cleanOrder: cleanOrder
}