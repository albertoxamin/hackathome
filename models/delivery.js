const mongoose = require('mongoose')

const Schema = mongoose.Schema
const ObjectId = Schema.ObjectId

const DeliverySchema = new Schema({
	company: ObjectId,
	orders: [ObjectId],
	vehicle: ObjectId,
	executionDate: { type: Date}, 
})

DeliverySchema.methods = {

}

mongoose.model('Delivery', DeliverySchema)