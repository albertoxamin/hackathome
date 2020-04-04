const mongoose = require('mongoose')

const Schema = mongoose.Schema

const GoodSchema = new Schema({
	picture: String,
	name: String,
	description: String,
	volume: {
		width: Number,
		depth: Number,
		height: Number
	},
	quantity: Number
})

GoodSchema.methods = {

}

mongoose.model('Good', GoodSchema)