package main

import (
	"crypto/tls"
	"devops-page/bootstrap"
	"devops-page/middleware/identity"
	"devops-page/routes"
	"golang.org/x/crypto/acme/autocert"
	"net/http"
	"strings"
)

func newApp() *bootstrap.Bootstrapper {
	app := bootstrap.New("Devops-page", "Denis Lavrushko")
	app.Bootstrap()
	app.Configure(identity.Configure, routes.Configure)
	return app
}

func main() {
	//app := newApp()
	//app.Listen(":443")
	// LetsEncrypt setup
	certManager := autocert.Manager{
		Prompt:     autocert.AcceptTOS,
		HostPolicy: autocert.HostWhitelist("dlavrushko.de"), // your domain here
		Cache:      autocert.DirCache("certs"),              // folder for storing certificates
	}
	server := &http.Server{
		Addr:      ":8081",
		TLSConfig: &tls.Config{GetCertificate: certManager.GetCertificate},
	}
	// open https server
	_ = server.ListenAndServeTLS("", "")

	// redirect everything to https
	go http.ListenAndServe(":80", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		reqhost := strings.Split(r.Host, ":")[0]
		http.Redirect(w, r, "https://"+reqhost+r.URL.Path, http.StatusMovedPermanently)
	}))
}
