const mongoose = require('mongoose')

const Schema = mongoose.Schema
const ObjectId = Schema.ObjectId

const OrderSchema = new Schema({
	customer: ObjectId,
	company: ObjectId,
	date: { type: Date, default: Date.now },
	goods: [ObjectId],
	executionDate: { type: Date}, 
})

OrderSchema.methods = {

}

mongoose.model('Order', OrderSchema)