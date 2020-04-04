const mongoose = require('mongoose')

const Schema = mongoose.Schema
const ObjectId = Schema.ObjectId

const CompanySchema = new Schema({
	owner: { type: ObjectId, ref: 'User' },
	employees: [{ type: ObjectId, ref: 'User' }],
	name: String,
	location: {
		lat: Number,
		lon: Number
	},
	logo: String,
	description: String,
	goods: [{ type: ObjectId, ref: 'Good' }]
})

CompanySchema.methods = {

}

mongoose.model('Company', CompanySchema)