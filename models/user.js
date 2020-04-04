const mongoose = require('mongoose')
const uuid = require('node-uuid')

const Schema = mongoose.Schema

const UserSchema = new Schema({
	accessToken: {
		type: String,
		unique: true
	},
	googleId: {
		type: String,
		unique: true
	},
	email: {
		type: String,
		unique: true
	},
	name: String,
	surname: String,
	picture: String,
	homeLocation: {
		lat: Number,
		lon: Number
	},
})

UserSchema.methods = {
	generateToken: function() {
		if (!this.accessToken) {
			this.accessToken = uuid.v4()
		}
	}
}

mongoose.model('User', UserSchema)