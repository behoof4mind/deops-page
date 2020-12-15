package main

import (
	"devops-page/bootstrap"
	"devops-page/middleware/identity"
	"devops-page/routes"
)

func newApp() *bootstrap.Bootstrapper {
	app := bootstrap.New("Russian DevOps page", "po4tatyt@gmail.com")
	app.Bootstrap()
	app.Configure(identity.Configure, routes.Configure)
	return app
}

func main() {
	app := newApp()
	app.Listen(":8080")
}
