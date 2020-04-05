const mongoose = require('mongoose')

const Schema = mongoose.Schema

const VehicleSchema = new Schema({
	name: String,
	maxVolume: {
		width: Number,
		depth: Number,
		height: Number
	},
})

VehicleSchema.methods = {

}

mongoose.model('Vehicle', VehicleSchema)