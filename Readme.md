![logo](logo.png)
# Anylivery
This project was developed for the [HackAtHome]([https://link](https://hackathome.crispybacon.it/)) hackathon.

## Intro

This is a PaaS (Platform as a service) that enables:
* Local business
  * to open a store front and add their products from the smartphone
  * manage orders and plan deliveries
* Customers
  * place orders to the stores
  * receive their orders at home

## Setting up
### Backend 
The backend was written in nodejs.

Go to the folder `backend`, create a folder `config` and add a file named `secrets.json` with the following secrets
```json
{
  "google": {
    "clientId": "",
    "clientSecret": "",
		"redirectUri": "[YOUR_URL]/auth/google/callback",
  },
  "mongodb": {
    "uri": ""
	},
	"heremaps":{
		"apikey": ""
	}
}
```

then open the terminal and execute this commands
```bash
yarn install
yarn start
```

You can then play with the APIs from this postman:

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/3e4a6e1658b7f424746b)

### Frontend

The frontend was written in flutter to provide a similar exprerience for both android and iOS, the code is located in the folder `flutter/hackathome_frontend`.

You can grab the builds from codemagic below or by running `flutter run` inside that folder

[![Codemagic build status](https://api.codemagic.io/apps/5e8b61c064e0bd70f25f5cbb/5e8b61c064e0bd70f25f5cba/status_badge.svg)](https://codemagic.io/apps/5e8b61c064e0bd70f25f5cbb/5e8b61c064e0bd70f25f5cba/latest_build)
