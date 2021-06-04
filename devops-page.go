package main

import (
	"devops-page/bootstrap"
	"devops-page/middleware/identity"
	"devops-page/routes"
	"fmt"
	"os"
	"regexp"
)

func newApp() *bootstrap.Bootstrapper {
	version, exists := os.LookupEnv("APP_VERSION")
	if !exists {
		version = "0.0.1"
	}
	app := bootstrap.New("Devops-page", "Denis Lavrushko", version)
	app.Bootstrap()
	app.Configure(identity.Configure, routes.Configure)
	return app
}

func main() {
	app := newApp()
	envType, envTypeExist := os.LookupEnv("TEST_RUN")
	if envTypeExist != true {
		fmt.Println("TEST_RUN environment variable did not specified. :443 port will be used")
		app.Listen(false, ":443")
	} else {
		r := regexp.MustCompile(`^(?i)true$`)
		if r.MatchString(envType) {
			app.Listen(true, ":8080")
		}

	}
}
