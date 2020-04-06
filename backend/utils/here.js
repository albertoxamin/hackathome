const request = require('request')
const config = require('../config/secrets.json')

const locStr = (pos) => `${pos.lat},${pos.lon}`

const ISODateString = (d) =>  {
	function pad(n) { return n < 10 ? '0' + n : n }
	return d.getUTCFullYear() + '-'
		+ pad(d.getUTCMonth() + 1) + '-'
		+ pad(d.getUTCDate()) + 'T'
		+ pad(d.getUTCHours()) + ':'
		+ pad(d.getUTCMinutes()) + ':'
		+ pad(d.getUTCSeconds()) + 'Z'
}

const getRoute = (base, stops, time, cb) => {
	time = ISODateString(new Date(time))
	let viaStops = stops.map(s => locStr(s)).join('&via=')
	let url = `https://router.hereapi.com/v8/routes?transportMode=car&origin=${locStr(base)}&destination=${locStr(base)}&via=${viaStops}&apikey=${config.heremaps.apikey}&departureTime=${time}`

	request.get(url, (err, res, body) => {
		if (err)
			return console.log(err)
		cb(JSON.parse(body).routes[0].sections)
	})
}

module.exports = {
	getRoute: getRoute
}