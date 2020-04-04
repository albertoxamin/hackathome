const mongoose = require('mongoose')

const Schema = mongoose.Schema
const ObjectId = Schema.ObjectId

const DeliverySchema = new Schema({
	company: { type: ObjectId, ref: 'Company' },
	orders: [{ type: ObjectId, ref: 'Order' }],
	vehicle: { type: ObjectId, ref: 'Vehicle' },
	executionDate: { type: Date}, 
})

DeliverySchema.methods = {

}

mongoose.model('Delivery', DeliverySchema)