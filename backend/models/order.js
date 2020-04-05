const mongoose = require('mongoose')

const Schema = mongoose.Schema
const ObjectId = Schema.ObjectId

const OrderSchema = new Schema({
	customer: { type: ObjectId, ref: 'User' },
	company: { type: ObjectId, ref: 'Company' },
	date: { type: Date, default: Date.now },
	goods: [{
		item: { type: ObjectId, ref: 'Good' },
		quantity: Number
	}],
	executionDate: { type: Date },
	completed: Boolean
})

OrderSchema.methods = {

}

mongoose.model('Order', OrderSchema)