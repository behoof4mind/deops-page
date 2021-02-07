package main

import (
	"devops-page/bootstrap"
	"devops-page/middleware/identity"
	"devops-page/routes"
)

func newApp() *bootstrap.Bootstrapper {
	app := bootstrap.New("Devops-page", "Denis Lavrushko")
	app.Bootstrap()
	app.Configure(identity.Configure, routes.Configure)
	return app
}

func main() {
	app := newApp()
	app.Listen(":443")
	//certmagic.DefaultACME.Agreed = true
	//certmagic.DefaultACME.Email = "dlavrushko@protonmail.com"
	//certmagic.HTTPS([]string{"dlavrushko.de"}, app)
}
