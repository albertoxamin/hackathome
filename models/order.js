const mongoose = require('mongoose')

const Schema = mongoose.Schema
const ObjectId = Schema.ObjectId

const OrderSchema = new Schema({
	customer: { type: ObjectId, ref: 'User' },
	company: { type: ObjectId, ref: 'Company' },
	date: { type: Date, default: Date.now },
	goods: [{ type: ObjectId, ref: 'Good' }],
	executionDate: { type: Date}, 
})

OrderSchema.methods = {

}

mongoose.model('Order', OrderSchema)