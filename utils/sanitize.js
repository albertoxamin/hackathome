const colors = require('colors')
const _ = require('lodash')

module.exports = {
	clean: function (obj, req) {
		try {
			obj = obj.toObject()
		} catch (err) { }
		if (Array.isArray(obj)) {
			_.map(obj, this.clean)
			return obj
		}
		obj.id = obj._id.toString()
		delete obj._id
		delete obj.__v
		delete obj.createdAt
		delete obj.updatedAt
		return obj
	},
	cleanError : function(res, err){
		console.log('500 '.red + err.message)
		res.status(500).send(err.message)
	}
}