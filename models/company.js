const mongoose = require('mongoose')

const Schema = mongoose.Schema
const ObjectId = Schema.ObjectId

const CompanySchema = new Schema({
	owner: ObjectId,
	employees: [ObjectId],
	location: {
		lat: Number,
		lon: Number
	},
	logo: String,
	description: String,
	goods: [ObjectId]
})

CompanySchema.methods = {

}

mongoose.model('Company', CompanySchema)