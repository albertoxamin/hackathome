const passport = require('passport')
const sanitize = require('../utils/sanitize')

module.exports = (router) => {
	router
		.route('/auth/google')
		.get(passport.authenticate('google', { scope: ['profile', 'email'] }))

	router
		.route('/auth/google/callback')
		.get(
			passport.authenticate('google', { failureRedirect: '/auth' }),
			(req, res) => {
				return res.send(`
				<style>
    html, body { margin: 0; padding: 0; }
    main {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      font-family: -apple-system,BlinkMacSystemFont,Segoe UI,Helvetica,Arial,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol;
    }
    #icon {
      font-size: 96pt;
    }
    #text {
      padding: 2em;
      max-width: 260px;
      text-align: center;
    }
    #button a {
      display: inline-block;
      padding: 6px 12px;
      color: white;
      border: 1px solid rgba(27,31,35,.2);
      border-radius: 3px;
      background-image: linear-gradient(-180deg, #34d058 0%, #22863a 90%);
      text-decoration: none;
      font-size: 14px;
      font-weight: 600;
    }
    #button a:active {
      background-color: #279f43;
      background-image: none;
    }
  </style>
				<main>
    <img style="width: 150px;border-radius: 150px;" src="${req.user.picture}"></img>
    <div id="text">${req.user.name} ${req.user.surname}</div>
    <div id="button"><a href="foobar://success?code=${req.user.accessToken}">Entra</a></div>
  </main>`);//sanitize.clean(req.user))
			}
		)
}